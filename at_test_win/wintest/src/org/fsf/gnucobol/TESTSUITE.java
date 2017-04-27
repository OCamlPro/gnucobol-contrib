package org.fsf.gnucobol;
/*
 * Copyright (C) 2017 Free Software Foundation, Inc.
 * Author: Sergey Kashyrin
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA  */

import java.io.*;
import java.util.*;

public final class TESTSUITE {
	private static boolean bKEEP = false;
	private final File fdir;
	private final File finclude;
	private       int                 testnum = 0;
	private       int                 failed  = 0;
	private       int                 passed  = 0;
	private       int                 skipped = 0;
	private       File                fwrkdir = null;
	private       PrintWriter         pwrk    = null;
	private       PrintWriter         pw      = null;
	private final Map<String, String> env     = new HashMap<String, String>();
	private final Map<String, String> tskip   = new HashMap<String, String>();
	private final Map<String, String> lskip   = new HashMap<String, String>();
	private final Map<String, String> repl    = new HashMap<String, String>();

	public TESTSUITE(File file) throws Exception {
		File fbase = file.getAbsoluteFile().getParentFile();
		fdir = new File(fbase, "testdir");
		if(!fdir.exists() && !fdir.mkdirs()) {
			throw new IllegalArgumentException("Can not create test directory " + fdir.getAbsolutePath());
		}
		pw = new PrintWriter(new File(fdir, "testsuite.log"));
		pw.println("Test cases Windows runner");
		pw.println("Copyright (C) 2017 Free Software Foundation, Inc.");
		pw.println("Written by Sergey Kashyrin");
		pw.println();
		File f = new File(fbase, "testsuite.src");
		if(!f.exists() || !f.isDirectory()) {
			f = fbase;
		}
		finclude = f;
		Map<String, String> sys = System.getenv();
		env.putAll(sys);
		for(int i = 0; i < senv.length; i += 2) {
			env.put(senv[i], senv[i + 1]);
		}
		f = new File(fbase, "wintest.properties");
		if(f.exists() && f.isFile()) {
			Properties p = new Properties();
			p.load(new FileReader(f));
			for(Object obj : p.keySet()) {
				String val = p.getProperty(obj.toString());
				env.put(obj.toString(), val);
			}
		}

		f = new File(fbase, "wintest_skip.properties");
		if(f.exists() && f.isFile()) {
			BufferedReader input = null;
			try {
				input = new BufferedReader(new FileReader(f));
				String line;
				while((line = input.readLine()) != null) {
					if(line.startsWith("skiptest=")) {
						tskip.put(line.substring(9).trim(), "");
						continue;
					}
					if(line.startsWith("skipline=")) {
						lskip.put(line.substring(9).trim(), "");
						continue;
					}
					if(line.startsWith("replace=")) {
						String s = input.readLine();
						if(s == null) s = "";
						repl.put(line.substring(8).trim(), s);
						continue;
					}
					if(line.trim().isEmpty() || line.trim().startsWith("#")) {
						continue;
					}
					System.out.println("*** Ignored incorrect syntax in wintest_skip.properties: " + line);
					pw.println("*** Ignored incorrect syntax in wintest_skip.properties: " + line);
				}
			} finally {
				if(input != null) try {
					input.close();
				} catch(Exception ignored) {}
			}
		}

		process(file);

		pw.println();
		pw.println("TESTS TOTAL: " + (failed + passed) + ", PASSED: " + passed + ", SKIPPED: " + skipped + ", FAILED: " + failed);
		pw.close();
		System.out.println();
		System.out.println("TESTS TOTAL: " + (failed + passed) + ", PASSED: " + passed + ", SKIPPED: " + skipped + ", FAILED: " + failed);
	}

	private String processV(String cmd) {
		if(cmd.equals("$COMPILE \"$(_return_path \"$(pwd)/prog.cob\")\"")) {
			File f = new File(fwrkdir, "prog.cob");
			cmd = "$COMPILE " + f.getAbsolutePath();
		}
		if(cmd.equals("$COMPILE_ONLY -conf=\"$(_return_path \"$(pwd)/test.conf\")\" prog.cob")) {
			File f = new File(fwrkdir, "test.conf");
			cmd = "$COMPILE_ONLY -conf=" + f.getAbsolutePath() + " prog.cob";
		}
		if(cmd.equals("$COBCRUN -c \"$(_return_path \"$(pwd)/test.cfg\")\" --runtime-conf")) {
			File f = new File(fwrkdir, "test.cfg");
			cmd = "$COBCRUN -c " + f.getAbsolutePath() + " --runtime-conf";
		}
		if(cmd.startsWith("echo \"")) {
			int ix = cmd.indexOf('"', 6);
			if(ix > 0) {
				cmd = "echo " + cmd.substring(6, ix) + cmd.substring(ix + 1);
			}
		}
		if(cmd.startsWith("sed ")) {
			cmd = cmd.replaceAll("'", "\"");
		}
		for(; ; ) {
			int ix = cmd.indexOf('$');
			if(ix < 0) {
				break;
			}
			if(cmd.length() > ix + 1 && cmd.charAt(ix + 1) == '{') {
				int ie = cmd.indexOf('}', ix);
				String var = (ie > 0) ? cmd.substring(ix + 2, ie) : cmd.substring(ix + 2);
				String val = env.get(var);
				if(val == null) val = "";
				cmd = cmd.substring(0, ix) + val + ((ie > 0) ? cmd.substring(ie + 1) : "");
				continue;
			}
			int ie = ix + 1;
			while(ie < cmd.length()) {
				char c = cmd.charAt(ie);
				if(!Character.isLetterOrDigit(c) && c != '_') {
					break;
				}
				++ie;
			}
			String var = cmd.substring(ix + 1, ie);
			String val = env.get(var);
			if(val == null) val = "";
			cmd = cmd.substring(0, ix) + val + (ie < cmd.length() ? cmd.substring(ie) : "");
		}
		return cmd;
	}

	private int processX(String cmd, List<String> out, List<String> err, boolean bSkip) throws Exception {
		if(cmd.startsWith("test \"$COB_HAS_CURSES\"")) {
			return 0;
		}
		List<String> var = new ArrayList<String>();
		while(cmd.startsWith("export ")) {
			cmd = cmd.substring(7).trim();
			// Need to find correct ";"
			String export = null;
			boolean inQ = false;
			boolean inq = false;
			for(int ix = 0; ix < cmd.length(); ++ix) {
				switch(cmd.charAt(ix)) {
				case '"':
					if(!inq) inQ = !inQ;
					continue;
				case '\'':
					if(!inQ) inq = !inq;
					continue;
				case ';':
					if(!inq && !inQ) break;
					continue;
				default:
					continue;
				}
				export = cmd.substring(0, ix);
				cmd = cmd.substring(ix + 1).trim();
				break;
			}
			if(export != null) {
				int ix = export.indexOf('=');
				if(ix > 0) {
					var.add(export.substring(0, ix).trim());
					export = processV(export.substring(ix + 1).trim());
					export = export.replaceAll("\"", "");
					var.add(export);
				} else {
					var.add(export.trim());
					var.add("");
				}
			}
		}
		cmd = processV(cmd).trim();
		if(cmd.startsWith("test \"yes\" = \"yes\"")) {
			return 0;
		}
		while(!cmd.startsWith("./") && !cmd.startsWith("cobc")) {
			int ix = cmd.indexOf(' ');
			if(ix < 0) break;
			String export = cmd.substring(0, ix);
			int ie = export.indexOf('=');
			if(ie < 0) break;
			cmd = cmd.substring(ix + 1).trim();
			var.add(export.substring(0, ie));
			var.add(export.substring(ie + 1).replaceAll("\"", ""));
		}
		if(cmd.startsWith("./")) cmd = cmd.substring(2);
		int ipipe = cmd.indexOf("| ./");
		if(ipipe > 0) cmd = cmd.substring(0, ipipe + 2) + cmd.substring(ipipe + 4);

		List<String> parms = new ArrayList<String>();
		parms.add("cmd.exe");
		parms.add("/c");
		parms.add(cmd);
		if(bSkip) {
			pwrk.println("skipping: " + cmd);
			return 0;
		}
		pwrk.println("executing: " + cmd);
		ProcessBuilder pb = new ProcessBuilder(parms);
		Map<String, String> penv = pb.environment();
		penv.putAll(env);
		if(!var.isEmpty()) {
			for(int i = 0; i < var.size(); i += 2) {
				penv.put(var.get(i), var.get(i + 1));
			}
		}
		pb.directory(fwrkdir);
		Process p;
		try {
			p = pb.start();
		} catch(IOException e) {
			return 1;   // command not found
		}
		BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		T t1 = new T(in, out);
		t1.start();
		in = new BufferedReader(new InputStreamReader(p.getErrorStream()));
		T t2 = new T(in, err);
		t2.start();
		t1.join();
		t2.join();
		return p.waitFor();
	}

	private static class T extends Thread {
		BufferedReader in;
		List<String>   out;

		public T(BufferedReader r, List<String> ls) {
			in = r;
			out = ls;
		}

		public void run() {
			try {
				for(String line = in.readLine(); line != null; line = in.readLine()) {
					out.add(line);
				}
				in.close();
			} catch(IOException ignored) {}
		}
	}

	private void writeF(String fname, List<String> content) throws IOException {
		BufferedWriter output = null;
		try {
			output = new BufferedWriter(new FileWriter(new File(fwrkdir, fname)));
			for(String s : content) {
				output.write(s);
				output.newLine();
			}
		} finally {
			if(output != null) try {
				output.close();
			} catch(Exception ignored) {}
		}
	}

	private static boolean getValue(BufferedReader input, String l, List<List<String>> v, int iCheck) throws Exception {
		int ix = l.indexOf('(');
		if(ix < 0) {
			return false;
		}
		String line = l.substring(ix + 1);
		int nParms = 0;
		boolean bBseen = false;
		for(; ; ) {
			while(line.endsWith("\\")) {
				String l2 = input.readLine();
				if(l2 == null) {
					l2 = "";
				}
				line = line.substring(0, line.length() - 1) + l2;
			}
			while(!line.isEmpty() && (line.charAt(0) == ' ' || line.charAt(0) == '\t')) {
				line = line.substring(1);
			}
			if(line.isEmpty()) {
				line = input.readLine();
				if(line == null) {
					return false;
				}
				continue;
			}
			if(line.charAt(0) == ')') {
				break;
			}
			if(line.charAt(0) == ',') {
				if(!bBseen) {
					v.add(new ArrayList<String>());
				}
				bBseen = false;
				line = line.substring(1);
				if(iCheck != 0 && nParms == iCheck) {
					List<String> lst = new ArrayList<String>();
					lst.add(line);
					v.add(lst);
					return true;
				}
				continue;
			}
			if(line.startsWith("ignore")) {
				List<String> ls = new ArrayList<String>();
				ls.add("ignore");
				v.add(ls);
				line = line.substring(6);
				continue;
			}
			if(line.charAt(0) != '[') { // possible if-else recursion
				throw new Exception("Incorrect format: " + l);
			}
			bBseen = true;
			++nParms;
			boolean bDup = false;
			List<String> lst = new ArrayList<String>();
			line = line.substring(1);
			if(!line.isEmpty() && line.charAt(0) == '[') {
				line = line.substring(1);
				bDup = true;
			}
			// collect everything before ']'
		L1:
			for(; ; ) {
				if(bDup) {
					ix = line.indexOf("]]");
					if(ix >= 0) {
						break;
					}
				} else {
					ix = line.indexOf(']');
					while(ix >= 0) {
						if(line.length() == ix + 1 || line.charAt(ix + 1) != ']') {
							break L1;
						}
						line = line.substring(0, ix) + line.substring(ix + 1);
						ix = line.indexOf(']', ix + 1);
					}
				}
				if(!bDup) {
					line = line.replaceAll("\\[\\[", "[");
				}
				lst.add(line);
				line = input.readLine();
				if(line == null) {
					v.add(lst);
					return false;
				}
			}
			String toadd = line.substring(0, ix);
			if(!bDup) {
				toadd = toadd.replaceAll("\\[\\[", "[");
			}
			if(!toadd.isEmpty()) {
				lst.add(toadd);
			}
			v.add(lst);
			line = line.substring(ix + (bDup ? 2 : 1));
		}
		return false;
	}

	private void process(File f) throws Exception {
		String prn = "Processing " + f.getAbsolutePath();
		System.out.println(prn);
		pw.println(prn);
		BufferedReader input = null;
		try {
			input = new BufferedReader(new FileReader(f));
			process2(input);
		} finally {
			if(input != null) try {
				input.close();
			} catch(Exception ignored) {}
		}
	}

	@SuppressWarnings("ConstantConditions")
	private boolean process2(BufferedReader input) throws Exception {
		boolean bFAILED = false;
		boolean bIgnore = false;
		boolean bSkiptest = false;
		String line;

		while((line = input.readLine()) != null) {
			if(line.trim().isEmpty() || line.charAt(0) == '#') {
				continue;
			}
			while(line.endsWith("\\")) {
				String l2 = input.readLine();
				if(l2 == null) {
					l2 = "";
				}
				line = line.substring(0, line.length() - 1) + l2;
			}
			if(lskip.get(line.trim()) != null) {
				continue;
			}
			String rpl = repl.get(line.trim());
			if(rpl != null) {
				line = rpl;
			}
			if(line.startsWith("m4_include")) {
				int ib = line.indexOf('[');
				int ie = line.indexOf(']');
				if(ib < 0 || ie < ib) {
					throw new Exception("Unrecognized m4 include: " + line);
				}
				File finc = new File(finclude, line.substring(ib + 1, ie));
				if(!finc.exists() || !finc.isFile()) {
					throw new Exception("Can not include file " + finc.getAbsolutePath());
				}
				process(finc);
				continue;
			}
			if(line.charAt(0) == '[') {
				line = line.substring(1);
			}
			if(line.startsWith("if ")) {
				if(line.trim().equals("if test \"x$COB_BIGENDIAN\" = \"xyes\"; then")) {
					String be = System.getenv("COB_BIGENDIAN");
					if(pwrk != null) pwrk.println(line + ": value " + be);
					if(be == null || !be.equalsIgnoreCase("yes")) {
						bIgnore = true;
					}
				} else if(pwrk != null) {
					pwrk.println("IGNORING testing: " + line);
				}
				continue;
			}
			if(line.startsWith("else")) {
				bIgnore = !bIgnore;
				if(pwrk != null) pwrk.println("else");
				continue;
			}
			if(line.trim().equals("fi")) {
				bIgnore = false;
				if(pwrk != null) pwrk.println("endif");
				continue;
			}
			if(bIgnore) {
				if(pwrk != null) pwrk.println("IGNORING: " + line);
				continue;
			}
			if(line.startsWith("export ")) {
				String export = processV(line.substring(7)).trim();
				int ix = export.indexOf('=');
				if(ix > 0) {
					String name = export.substring(0, ix).trim();
					export = processV(export.substring(ix + 1).trim());
					export = export.replaceAll("\"", "");
					env.put(name, export);
				} else {
					env.put(export.trim(), "");
				}
				continue;
			}
			if(!line.startsWith("AT_")) {
				if(bSkiptest) {
					pwrk.println("SKIPPING: " + line);
					continue;
				}
				List<String> out = new ArrayList<String>();
				List<String> err = new ArrayList<String>();
				int rc = processX(line, out, err, false);
				if(pwrk != null) {
					pwrk.println("EXECUTING: " + line);
					pwrk.println("RC: " + rc);
					if(!out.isEmpty()) {
						pwrk.println("STDOUT");
						for(String s : out) {
							pwrk.println(s);
						}
						pwrk.println("END STDOUT");
					}
					if(!err.isEmpty()) {
						pwrk.println("STDERR");
						for(String s : err) {
							pwrk.println(s);
						}
						pwrk.println("END STDERR");
					}
				}
				continue;
			}
			if(line.startsWith("AT_COPYRIGHT(") || line.startsWith("AT_INIT(") || line.startsWith("AT_BANNER(")) {
				List<List<String>> llst = new ArrayList<List<String>>();
				getValue(input, line, llst, 0);
				for(List<String> lst : llst) {
					for(String s : lst) {
						System.out.println(s);
						pw.println(s);
					}
				}
				pw.println();
				System.out.println();
				System.out.flush();
				continue;
			}
			if(line.startsWith("AT_SETUP(")) {
				++testnum;
				bFAILED = false;
				fwrkdir = new File(fdir, "test" + testnum);
				if(!fwrkdir.exists() && !fwrkdir.mkdirs()) {
					throw new Exception("Can not create directory " + fwrkdir.getAbsolutePath());
				}
				pwrk = new PrintWriter(new File(fwrkdir, "result.txt"));
				String hdr = Integer.toString(testnum);
				while(hdr.length() < 4) {
					hdr = ' ' + hdr;
				}
				hdr += "  ";
				List<List<String>> llst = new ArrayList<List<String>>();
				getValue(input, line, llst, 0);
				for(List<String> lst : llst) {
					for(String s : lst) {
						if(tskip.get(s.trim()) != null) {
							bSkiptest = true;
						}
						s = hdr + s;
						while(s.length() < 60) { s += ' '; }
						s += " ...";
						System.out.print(s);
						pwrk.println(s);
						pw.print(s);
					}
				}
				System.out.flush();
				continue;
			}
			if(line.startsWith("AT_TESTED(") || line.startsWith("AT_KEYWORDS(")) {
				List<List<String>> llst = new ArrayList<List<String>>();
				getValue(input, line, llst, 0);
				continue;
			}
			if(line.startsWith("AT_CAPTURE_FILE(")) {
				List<List<String>> llst = new ArrayList<List<String>>();
				getValue(input, line, llst, 0);
				continue;
			}
			if(line.startsWith("AT_SKIP_IF(")) {
				continue;
			}
			if(line.startsWith("AT_XFAIL_IF(")) {
				continue;
			}
			if(line.trim().equals("AT_CLEANUP")) {
				if(pwrk != null) {
					pwrk.close();
					pwrk = null;
				}
				if(!bSkiptest && bFAILED) {
					System.out.println("  FAILED");
					pw.println("  FAILED");
					++failed;
				} else {
					if(bSkiptest) {
						System.out.println("  SKIPPED");
						pw.println("  SKIPPED");
						++skipped;
						bSkiptest = false;
					} else {
						System.out.println("  PASSED");
						pw.println("  PASSED");
						++passed;
					}
					if(!bKEEP) {
						// try to remove dir
						File[] list = fwrkdir.listFiles();
						if(list != null) {
							for(File f : list) {
								@SuppressWarnings("unused") boolean rc = f.delete();
							}
						}
						@SuppressWarnings("unused") boolean rc = fwrkdir.delete();
					}
				}
				bFAILED = false;
				continue;
			}
			if(line.trim().equals("AT_COLOR_TESTS")) {
				continue;
			}
			if(line.startsWith("AT_DATA(")) {
				List<List<String>> llst = new ArrayList<List<String>>();
				getValue(input, line, llst, 0);
				if(llst.size() != 2) {
					System.out.println("??? What to do with this data " + llst.size());
					continue;
				}
				List<String> lst = llst.get(0);
				if(lst.size() != 1) {
					System.out.println("??? What to do with the file " + lst.size());
					continue;
				}
				String fname = lst.get(0);
				writeF(fname, llst.get(1));
				continue;
			}
			if(line.startsWith("AT_CHECK(")) {
				List<List<String>> llst = new ArrayList<List<String>>();
				boolean bCont = getValue(input, line, llst, 4);
				List<String> out = new ArrayList<String>();
				List<String> err = new ArrayList<String>();
				String cmd = llst.get(0).get(0);
				if(cmd.equals("true")) {
					continue;
				}
				int rc = processX(cmd, out, err, bSkiptest);
				if(llst.size() > 1 && !llst.get(1).isEmpty()) {
					// check return code
					int exprc = Integer.parseInt(llst.get(1).get(0));
					if(exprc != rc) {
						pwrk.println("Expected Retcode " + exprc + ", Retcode " + rc);
						bFAILED = true;
					}
					if(llst.size() > 2) {
						boolean bFailed = false;
						List<String> expout = llst.get(2);
						if(expout.size() != 1 || !expout.get(0).equals("ignore")) {
							if(expout.size() != out.size()) {
								bFailed = true;
							} else {
								for(int i = 0; i < out.size(); ++i) {
									if(!expout.get(i).equals(out.get(i))) {
										bFailed = true;
										break;
									}
								}
							}
							if(bFailed) {
								bFAILED = true;
								pwrk.println("EXPECTED STDOUT");
								for(String s : expout) {
									pwrk.println(s);
								}
								pwrk.println("REAL STDOUT");
								for(String s : out) {
									pwrk.println(s);
								}
								pwrk.println("END STDOUT");
							}
						}
					}
					if(llst.size() > 3) {
						boolean bFailed = false;
						List<String> experr = llst.get(3);
						if(experr.size() != 1 || !experr.get(0).equals("ignore")) {
							if(experr.size() != err.size()) {
								bFailed = true;
							} else {
								for(int i = 0; i < err.size(); ++i) {
									if(!experr.get(i).equals(err.get(i))) {
										bFailed = true;
										break;
									}
								}
							}
							if(bFailed) {
								bFAILED = true;
								pwrk.println("EXPECTED STDERR");
								for(String s : experr) {
									pwrk.println(s);
								}
								pwrk.println("REAL STDERR");
								for(String s : err) {
									pwrk.println(s);
								}
								pwrk.println("END STDERR");
							}
						}
					}
				}
				if(bCont) {
					String linex = llst.get(4).get(0);
					while(!linex.isEmpty() && linex.charAt(0) == ' ') { linex = linex.substring(1); }
					if(linex.length() <= 1 || linex.charAt(0) != '[' || linex.charAt(1) != ']') {
						StringBuilder sb = new StringBuilder();
						int c = getChunk(input, sb);
						boolean bF = bFAILED;
						if(bF) {
							// if failed go there
							BufferedReader br = new BufferedReader(new StringReader(sb.toString()));
							bFAILED = process2(br);
						}
						if(c == ',') {
							sb = new StringBuilder();
							@SuppressWarnings("unused") int ic = getChunk(input, sb);
							if(!bF) {
								// if succeeded
								BufferedReader br = new BufferedReader(new StringReader(sb.toString()));
								bFAILED = process2(br);
							}
						}
					}
					// else ignore failure
				}
				continue;
			}
			System.out.println("Ignoring " + line);
		}
		return bFAILED;
	}

	private int getChunk(BufferedReader r, StringBuilder sb) throws Exception {
		boolean bBr = false;
		int c;
		for(; ; ) {
			c = getch(r);
			if(c != ' ' && c != '\t' && c != '\r' && c != '\n') {
				break;
			}
		}
		if(c == '[') {
			bBr = true;
		} else {
			cc = c;
		}
		int inC = 0;
		int inK = 0;
	L2:
		for(; ; ) {
			c = getch(r);
			if(c < 0) break;
			switch((char) c) {
			case '(':
				++inC;
				break;
			case ')':
				--inC;
				if(inC < 0) break L2;
				break;
			case '[':
				++inK;
				int x = getch(r);
				if(x != '[') {
					cc = x;
				}
				break;
			case ']':
				--inK;
				x = getch(r);
				if(x != ']') {
					cc = x;
				}
				if(inK < 0) {
					if(!bBr) break L2;
					inK = 0;
					continue;
				}
				break;
			case ',':
				if(inK == 0 && inC == 0) break L2;
			}
			sb.append((char) c);
		}
		return c;
	}

	int cc = -1;

	int getch(Reader r) throws Exception {
		if(cc < 0) {
			return r.read();
		}
		int c = cc;
		cc = -1;
		return c;
	}

	public static void main(String[] args) {
		if(args.length == 0 || args.length > 2) {
			System.out.println("Usage: java -cp wintest.jar [-keep] org.fsf.gnucobol.TESTSUITE path-to-testsuite.at");
			return;
		}
		int nf = 0;
		if(args[0].equalsIgnoreCase("-keep")) {
			bKEEP = true;
			++nf;
		}
		File f = null;
		if(args.length > nf) {
			f = new File(args[nf]);
		}
		if(f == null || !f.exists() || !f.isFile()) {
			if(f != null) System.out.println("ERROR: File does not exist: " + f.getAbsolutePath());
			System.out.println("Usage: java -cp wintest.jar [-keep] org.fsf.gnucobol.TESTSUITE path-to-testsuite.at");
			return;
		}
		try {
			@SuppressWarnings("unused") TESTSUITE c = new TESTSUITE(f);
		} catch(Exception t) {
			System.out.println("TESTSUITE ERROR: " + t);
			t.printStackTrace();
		}
	}

	private static final String[] senv = {
		"COBC", "cobc",
		"COBCRUN", "cobcrun",
		"COMPILE_ONLY", "cobc -fsyntax-only -debug -Wall",
		"COMPILE", "cobc -x -debug -Wall",
		"COMPILE_MODULE", "cobc -m -debug -Wall",
		};
}
