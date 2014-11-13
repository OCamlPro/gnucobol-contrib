       >> SOURCE FORMAT IS FREE
identification division.
program-id. checkfilestatus.

data division.
working-storage section.
01  status-message pic x(72).
01  display-message pic x(72) value spaces.

linkage section.
01  file-name pic x(64).
01  file-status pic x(2).

procedure division using file-name file-status.
start-checkfilestatus.
    if file-status = '00' or '10'
        goback
    end-if
    evaluate file-status
    when 00 move 'SUCCESS.' TO status-message   
    when 02 move 'SUCCESS DUPLICATE.' TO status-message 
    when 04 move 'SUCCESS INCOMPLETE.' TO status-message 
    when 05 move 'SUCCESS OPTIONAL.' TO status-message 
    when 07 move 'SUCCESS NO UNIT.' TO status-message 
    when 10 move 'END OF FILE.' TO status-message 
    when 14 move 'OUT OF KEY RANGE.' TO status-message 
    when 21 move 'KEY INVALID.' TO status-message 
    when 22 move 'KEY EXISTS.' TO status-message 
    when 23 move 'KEY NOT EXISTS.' TO status-message 
    when 30 move 'PERMANENT ERROR.' TO status-message 
    when 31 move 'INCONSISTENT FILENAME.' TO status-message 
    when 34 move 'BOUNDARY VIOLATION.' TO status-message 
    when 35 move 'FILE NOT FOUND.' TO status-message 
    when 37 move 'PERMISSION DENIED.' TO status-message 
    when 38 move 'CLOSED WITH LOCK.' TO status-message 
    when 39 move 'CONFLICT ATTRIBUTE.' TO status-message 
    when 41 move 'ALREADY OPEN.' TO status-message 
    when 42 move 'NOT OPEN.' TO status-message 
    when 43 move 'READ NOT DONE.' TO status-message 
    when 44 move 'RECORD OVERFLOW.' TO status-message 
    when 46 move 'READ ERROR.' TO status-message 
    when 47 move 'INPUT DENIED.' TO status-message 
    when 48 move 'OUTPUT DENIED.' TO status-message 
    when 49 move 'I/O DENIED.' TO status-message 
    when 51 move 'RECORD LOCKED.' TO status-message 
    when 52 move 'END-OF-PAGE.' TO status-message 
    when 57 move 'I/O LINAGE.' TO status-message 
    when 61 move 'FILE SHARING FAILURE.' TO status-message 
    when 91 move 'FILE NOT AVAILABLE.' TO status-message    
    end-evaluate
    string 'ERROR ' delimited by size
        file-name delimited by space
        space delimited by size
        status-message delimited by '.'
        into display-message
    end-string
    display display-message end-display
    stop run
    .
end program checkfilestatus.

