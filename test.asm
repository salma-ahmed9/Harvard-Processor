#        All numbers are in hex format
#        We always start by reset signal (in phase one, it just reset all registers)
#         This is a commented line
#        You should ignore empty lines and commented ones
#         add as much NOPs as you want to avoid hazards (as a software solution, just in 
#          phase one)
# ---------- Don't forget to Reset before you start anything ---------- #


.org 0                        # means the code start at address zero, this could be written in 
                        # several places in the file and the assembler should handle it in Phase 2


IN R5                        #R5= 0001 -->       
#needs 5 NOPS 
IN R2                        #R2= 0002 --> 
