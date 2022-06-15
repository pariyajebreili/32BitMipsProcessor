module RegisterFile(ReadRegister1, ReadRegister2, WriteData, WriteReg,RegWriteActive, ReadData1, ReadData2);

    // WriteData: the data to write
    // WriteReg: number of register to write
    // RegWriteActive: control signal for writing register => 1: write - 0: not write

    input [4:0] ReadRegister1;
    input [4:0] ReadRegister2;
    input [31:0] WriteData;
    input [4:0] WriteReg;
    input RegWriteActive;

    output reg [31:0] ReadData1;
    output reg [31:0] ReadData2;

    integer i;


    reg [31:0] RegFile [0:31];

    always @ (ReadRegister1 or ReadRegister2 or WriteData or WriteReg or RegWriteActive)
    begin
        ReadData1 = RegFile[ReadRegister1];
        ReadData2 = RegFile[ReadRegister2];

        if (RegWriteActive)
            RegFile[WriteReg] = WriteData;

    end


    initial begin
        RegFile[0] = 32'b0000000000000000000000000000000; // 0
        RegFile[1] = 32'b0000000000000000000000000000100; // 4
        RegFile[2] = 32'b0000000000100000000000000000100; // 1048580
        RegFile[3] = 32'b0000000000100000000000000000101; // 1048581
        RegFile[4] = 32'b0000000000100000000000000010100; // 1048596
        RegFile[5] = 32'b0000000000000000000010000010100; // 1044
        RegFile[6] = 32'b0000000000100000100000000010100; // 1064980
        RegFile[7] = 32'b0001000000100000000000000010100; // 135266324
        // RegFile[8] = 32'b0000000000000000000000000000000;
        // RegFile[9] = 32'b0000000000000000000000000000000;
        // RegFile[10] = 32'b0000000000000000000000000000000;
        // RegFile[11] = 32'b0000000000000000000000000000000;
        // RegFile[12] = 32'b0000000000000000000000000000000;
        // RegFile[13] = 32'b0000000000000000000000000000000;
        // RegFile[14] = 32'b0000000000000000000000000000000;
        // RegFile[15] = 32'b0000000000000000000000000000000;
        // RegFile[16] = 32'b0000000000000000000000000000000;
        // RegFile[17] = 32'b0000000000000000000000000000000;
        // RegFile[0] = 32'b0000000000000000000000000000000;
        // RegFile[0] = 32'b0000000000000000000000000000000;
        // RegFile[0] = 32'b0000000000000000000000000000000;
        // RegFile[0] = 32'b0000000000000000000000000000000;
        // RegFile[0] = 32'b0000000000000000000000000000000;
        for(i = 8; i <= 32; i = i + 1)
           RegFile[i] = 32'b0000000000000000000000000000000;
    end



endmodule
