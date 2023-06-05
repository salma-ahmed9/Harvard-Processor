################################################
###############################################
# fixed values
zeros = "00000000000000000000000000000000"

opCodeDict = {
    "MOV": "00000",
    "NOT": "00001",
    "INC": "00010",
    "DEC": "00011",
    "ADD": "00100",
    "SUB": "00101",
    "AND": "00110",
    "OR": "00111",

    "LDM": "01000",
    "IADD": "01001",
    "LDD": "01010",
    "STD": "01011",

    "NOP": "10000",
    "JZ": "10001",
    "JC": "10010",
    "JMP": "10011",
    "SETC": "10100",
    "CLRC": "10101",
    "IN": "10110",
    "OUT": "10111",

    "CALL": "11000",
    "PUSH": "11001",
    "RET": "11010",
    "POP": "11011",
    "RTI": "11100",
}

regDict = {

    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111",
}


def hexToBinary(hexNum):  # hexadecimal number to convert
    binaryNum = bin(int(hexNum, 16))[2:]
    return binaryNum


####################################################
####################################################


memoryStartComments = ["// memory data file (do not edit the following line - required for mem load use)\n",
                       "// instance=/processor/myFetch/MyinstructionCache/instructionCache\n", "// format=mti addressradix=h dataradix=s version=1.0 wordsperline=1\n"]

# this comments should be written at the start of the memfile
instructionCacheFile = open('InstCache.mem', 'w')
instructionCacheFile.writelines(memoryStartComments)


###########################################
############################################
# reading the assembler file
CurrMemLocation = 0

# filename = input('Please Enter the file name Only (extension is not needed)')
# Using readlines()
assemblyFile = open("test"+'.asm', 'r')
Lines = assemblyFile.readlines()
listOfInstructions = list()
listOfArguments = list()
count = 0
# Strips the newline character
for line in Lines:
    # here we will take the line as it and split the comment
    inputList = line.split("#")
    # skip the empty lines
    if inputList[0] == '':
        continue
    # strip() will remove the white space at the end of the command
    inputList[0] = inputList[0].strip()
    fullInstruction = inputList[0].split(" ")
    # skip the empty lines
    if inputList[0] == '':
        continue

    listOfInstructions.append(fullInstruction[0])
    if len(fullInstruction) != 1:  # for no argument commands
        listOfArguments.append(fullInstruction[1])
    else:
        listOfArguments.append(" ")

    # skip the empty lines
    if inputList[0] == '':
        continue
    count += 1

   # print("Line{}: {}".format(count, inputList[0].strip()))

# 1: 00000000000000000000000000000000

print('list of insts', listOfInstructions)
print('list of args', listOfArguments)
#######################################
#######################################
count = 0
CurrMemLocation = 0
ReadMemoryLocation = 0
for instruction in listOfInstructions:
   #  if CurrMemLocation == 12:
   #      print(help)
    if instruction.isnumeric():
        # print('found instruction', instruction)
        # number indicating something to be written in memory
        instructionBinary = str(bin(int(instruction, base=16)))[2:]
        # 32 is the length of the binary in MEMORY
        zeroNeedToBeAdded = 32-len(instructionBinary)
        instructionBinary = zeros[0:zeroNeedToBeAdded] + instructionBinary
        instructionBinary = '   ' + \
            str(hex(CurrMemLocation))[2:]+": "+instructionBinary+"\n"
        instructionCacheFile.writelines(instructionBinary)
        count += 1
        continue
    argument = str()
    argument = listOfArguments[count]
    instructionBinary = ''
    if instruction == ".org":
        CurrMemLocation = int(argument, 16)
        ReadMemoryLocation = CurrMemLocation
      #   if CurrMemLocation == 0:
      #       count += 1
      #       continue
      #   argument = hexToBinary(argument)
      #   zeroNeedToBeAdded = 32-len(argument)
      #   instructionBinary += zeros[0:zeroNeedToBeAdded]
      #   instructionBinary = '   '+"0"+": "+instructionBinary+argument+"\n"
      #   instructionCacheFile.writelines(instructionBinary)
        count += 1
        continue

    instructionBinary += opCodeDict[instruction]
    parsedArgument = argument.split(",")
    # flag makes STD skips a position in args
    flagForSTD = 0
    flagforLDD = 0
    for parameter in parsedArgument:
        # this takes no paramters :nop ,set ,clear
        if parameter == ' ' or parameter == '':
            continue
        #####################################################
        # handling special cases
        # we skip first arg for these
        if instruction == "JMP" or instruction == "JZ" or instruction == "JC" or instruction == "OUT" or instruction == "CALL":
            instructionBinary += "000"+regDict[parameter]
            continue
        # we skip 2 args for push
        if instruction == "PUSH":
            instructionBinary += "000000"+regDict[parameter]
            continue
        # we add imm value for IADD
        if parameter[0] != "R" and instruction == "IADD":
            parameter = "000"+hexToBinary(parameter)
            instructionBinary += parameter
            continue
        # we also add imm value for LDM
        if parameter[0] != "R" and instruction == "LDM":
            parameter = "000000"+hexToBinary(parameter)
            instructionBinary += parameter
            continue
        # we skip first arg for STD
        if instruction == "STD" and flagForSTD == 0:
            instructionBinary += "000"+regDict[parameter]
            flagForSTD = 1
            continue
        # we skip second arg for LDD
        if instruction == "LDD" and flagforLDD == 1:
            instructionBinary += "000"+regDict[parameter]
        ######################################################
        # if not instruction.isnumeric():
        # print('parameter', parameter, regDict[parameter])
        instructionBinary += regDict[parameter]
        flagforLDD = 1
    # 32 is the length of the binary in INSTRUCTION CACHE
    zeroNeedToBeAdded = 32-len(instructionBinary)
    instructionBinary += zeros[0:zeroNeedToBeAdded]
    instructionBinary = '   ' + \
        str(hex(CurrMemLocation))[2:]+": "+instructionBinary+"\n"
    count += 1
    CurrMemLocation += 1
    #########################################
    #########################################
    instructionCacheFile.writelines(instructionBinary)


########################################
######################################


instructionCacheFile.close()
