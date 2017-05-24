01  AnageRec.
   *> **************************************************************
   *>  copy 'GC71CRUDEREC.CPY'.
   *>  ANAGExxx.DAT: Anagrafica agenti                   LREC = 400
   *> **************************************************************
   *>
   *> The FILE has a RECID as primary key. RECID is a counter.
   *> The FILE has 3 alternative keys: .code, name, Fiscal code
   *> The fiule contains a record with primary key = 999999999
   *> wich contains the last numer (RECID) used.
   *>
   *> **************************************************************
       03 AnageKey    pic 9(09). *> RECID = file primary key
       03 AnageCodAge pic x(10). *> code AGENT
       03 AnageCodFis pic x(16). *> FISCAL CODE
       03 AnageRagSoc pic x(30). *> NAME
       03 AnageParIVA pic x(11). *> VAT CODE
       03 AnageMatEna pic x(08). *> matricola enasarco agente
       03 AnageIndLeg pic x(30). *> indirizzo agente
       03 AnageCapLeg pic x(05). *> ZIP
       03 AnageLocLeg pic x(30). *> localita'
       03 AnageProLeg pic x(02). *> provincia
       03 AnageTelCas pic x(14). *> telefono casa
       03 AnageTelCel pic x(14). *> telefono cellulare
       03 AnageTelFax pic x(14). *> fax
       03 AnageDataNa pic x(08). *> data di nascita AAAAMMGG
       03 AnageDataNa9 redefines AnageDataNa pic 9(8).
       03 AnageLocaNa pic x(30). *> localita' di nascita
       03 AnageProvNa pic x(02). *> provincia di nascita
       03 AnageTipCon pic x(01). *> tipo contratto Enasarco
       03 AnageTipSog pic x(01). *> tipo soggetto
       03 AnageSubage pic x(01). *> ha subagenti = S (x % rit.acc)
       03 AnageDataIn pic x(08). *> data inizio attivita' AAAAMMGG
       03 AnageDataIn9 redefines AnageDataIn pic 9(8).
       03 AnageDataCe pic x(08). *> data cessazione attivita' AAAAMMGG
       03 AnageDataCe9 redefines AnageDataCe pic 9(8).
       03 AnageTipoCe pic x(01). *> causale di cessazione
       03 AnageAntici pic s9(07)V99. *> anticipo fisso mensile
       03 AnageTraSin pic s9(07)V99. *> trattenuta sindacale
       03 AnageConSpe pic s9(07)V99. *> concorso spese fisso
       03 AnagePerIva pic 9(02). *> percentuale IVA
       03 AnageReteVe pic x(06). *> rete di vendita x statistiche
       03 AnageZonaVe pic x(06). *> zona di vendita x statistiche
       03 AnageCamCom pic x(09). *> iscriz.cam.commercio reg.ditte
       03 AnageNumRuo pic x(06). *> num.ruolo agenti
       03 AnageIscTri.              *> ex num.iscr tribunale ora:
          05 AnageIscRim pic x(18). *> iscriz.reg.delle imprese
       03 AnageCapSoc pic 9(12). *> capitale sociale in lire
       03 AnageCodFor pic x(06). *> cod.fornitore in nezoom
       03 AnageCodcdc pic x(06). *> cod.centro di costo
       03 AnageCasPos pic x(06). *> cod.ufficio posta interno
       03 AnageProvvi pic x(14). *> descriz.delle % provvigionali
       03 filler      pic x(12).
       03 AnageSetCon pic x(04). *> Settore Contabile
       03 AnageTipLiq pic x(01). *> tipo liquidaz.(acconti+cong/effe
       03 AnageNumAut pic x(01). *> numeraz.autom.fatture ? blank/S
       03 AnageAssicu pic s9(05)V99. *> assicurazione trattenere da firr
       03 AnageSesso  pic x(01).
       03 filler      pic x(03).
