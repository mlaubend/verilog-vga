`timescale 1ns / 1ps

module vga_display(button, rst, clk, R, G, B, HS, VS, R_control, G_control, B_control);
        input rst;      // global reset
        input clk;      // 100MHz clk
        input button; // button
        wire [6:0] seven;

        // color inputs for a given pixel
        input [2:0] R_control, G_control;
        input [1:0] B_control;

        // color outputs to show on display (current pixel)
        output reg [2:0] R, G;
        output reg [1:0] B;

        // Synchronization signals
        output HS;
        output VS;

        // controls:
        wire [10:0] hcount, vcount;     // coordinates for the current pixel
        wire blank;     // signal to indicate the current coordinate is blank
        wire figure;    // the figure you want to display

        /////////////////////////////////////////////////////
        // Begin clock division
        parameter N = 2;        // parameter for clock division
        reg clk_25Mhz;
        reg [N-1:0] count;
        always @ (posedge clk) begin
                count <= count + 1'b1;
                clk_25Mhz <= count[N-1];
        end
        // End clock division
        /////////////////////////////////////////////////////

        // Call driver
        vga_controller_640_60 vc(
                .rst(rst),
                .pixel_clk(clk_25Mhz),
                .HS(HS),
                .VS(VS),
                .hcounter(hcount),
                .vcounter(vcount),
                .blank(blank));

        // Call Lab 3
        lab3 L3(clk, button, rst, seven);

        // create a box:
        assign figure = ~blank & (hcount >= 300 & hcount <= 500 & vcount >= 167 & vcount <= 367);

        // create a figure
        assign a = (hcount >= 330 & hcount <= 470 & vcount >= 161 & vcount <= 181);
        assign b = (hcount >= 480 & hcount <= 499 & vcount >= 181 & vcount <= 250);
        assign c = (hcount >= 480 & hcount <= 499 & vcount >= 270 & vcount <= 340);
        assign d = (hcount >= 330 & hcount <= 470 & vcount >= 341 & vcount <= 361);
        assign e = (hcount >= 301 & hcount <= 320 & vcount >= 270 & vcount <= 340);
        assign f = (hcount >= 301 & hcount <= 320 & vcount >= 181 & vcount <= 250);
        assign g = (hcount >= 330 & hcount <= 470 & vcount >= 251 & vcount <= 269);

        // Insert your logic for displaying numbers in the following code section:

        always @ (posedge clk) begin
        if (figure) begin
                R = R_control;
                G = G_control;
                B = B_control;
                if (a == 1) begin
                        if (!seven[6]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (b == 1) begin
                        if (!seven[5]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (c == 1) begin
                        if (!seven[4]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (d == 1) begin
                        if (!seven[3]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (e == 1) begin
                        if (!seven[2]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (f == 1) begin
                        if (!seven[1]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                if (g == 1) begin
                        if (!seven[0]) begin
                                R = 1;
                                G = 1;
                                B = 1;
                                end
                        else begin
                                R = R_control;
                                G = G_control;
                                B = B_control;
                        end
                        end
                        end
        else begin      // if you are outside the valid region
                        R = 0;
                        G = 0;
                        B = 0;
                end
                end




        // send colors:
        /*always @ (posedge clk) begin
                if (figure) begin       // if you are within the valid region
                        R = R_control;
                        G = G_control;
                        B = B_control;
                end
                else begin      // if you are outside the valid region
                        R = 0;
                        G = 0;
                        B = 0;
                end
        end*/

endmodule

module lab3(
    input clk,
    input button,
    input reset,
    output [6:0] seven
    );

reg [3:0] count;
initial count <= 0;

debouncer D1(clk, button, clean);

always@(posedge clk)
begin
        if(clean == 1)
                count = count + 1;
        else if(reset == 1)
                count = 0;
end

binary_to_seven B1(seven, count);

endmodule


module debouncer (clk, button, clean);

input clk, button;
output reg clean;
parameter delay = 300000;
reg [21:0] delay_count;

initial delay_count = 0;

always @ (posedge clk) begin

if (button == 1)
        begin
                if (delay_count == delay)
                        begin
                        delay_count <= delay_count + 1'b1;
                        clean <= 1'b1;
                        end

                else
                        begin
                                if (delay_count == 22'b11_1111_1111_1111_1111_1111)
                                        clean <= 1'b0;
                                else
                                        begin
                                        delay_count <= delay_count + 1'b1;
                                        clean <= 1'b0;
                                        end
                        end
        end
else
        begin
        delay_count <= 0;
        clean <= 0;
        end
end
endmodule

module binary_to_seven(seven, count);
input[3:0]count;
output reg [6:0] seven;
always @(*)
case(count)
    4'b0000: seven = 7'b0000001;
    4'b0001: seven = 7'b1001111;
    4'b0010: seven = 7'b0010010;
    4'b0011: seven = 7'b0000110;
    4'b0100: seven = 7'b1001100;
    4'b0101: seven = 7'b0100100;
    4'b0110: seven = 7'b0100000;
    4'b0111: seven = 7'b0001111;
    4'b1000: seven = 7'b0000000;
    4'b1001: seven = 7'b0000100;
    4'b1010: seven = 7'b0001000;
    4'b1011: seven = 7'b1100000;
    4'b1100: seven = 7'b0110001;
    4'b1101: seven = 7'b1000010;
    4'b1110: seven = 7'b0110000;
    4'b1111: seven = 7'b0111000;

    default: seven = 7'b1111111;
endcase
endmodule

module vga_controller_640_60 (rst,pixel_clk,HS,VS,hcounter,vcounter,blank);

	input rst, pixel_clk;	// global reset, pixel clock
	output reg HS, VS, blank;	// sync controls, blank indicator
	output reg [10:0] hcounter, vcounter;	// pixel coordinates

	parameter HMAX = 800; 	// maxium value for the horizontal pixel counter
	parameter VMAX = 525; 	// maxium value for the vertical pixel counter
	parameter HLINES = 640;	// total number of visible columns
	parameter HFP = 648; 	// value for the horizontal counter where front porch ends
	parameter HSP = 744; 	// value for the horizontal counter where the synch pulse ends
	parameter VLINES = 480;	// total number of visible lines
	parameter VFP = 482; 	// value for the vertical counter where the frone proch ends
	parameter VSP = 484; 	// value for the vertical counter where the synch pulse ends
	parameter SPP = 0;		// value for the porch synchronization pulse

	wire video_enable;	// valid region indicator
	
	// create a "blank" indicator
	always@(posedge pixel_clk)begin
		blank <= ~video_enable; 
	end
	
	// Create a horizontal beam trace (horizontal time):
	always@(posedge pixel_clk)begin
		if(rst == 1) hcounter <= 0;
		else if (hcounter == HMAX) hcounter <= 0;
		else hcounter <= hcounter + 1'b1;
	end
	
	// Create a vertical beam trace (vertical time):
	always@(posedge pixel_clk)begin
		if(rst == 1) vcounter <=0;
		else if(hcounter == HMAX) begin
			if(vcounter == VMAX) vcounter <= 0;
			else vcounter <= vcounter + 1'b1; 
		end
	end
	
	// Check if between horizontal porches,
	// if not send horizontal porch synchronization pulse
	always@(posedge pixel_clk)begin
		if(hcounter >= HFP && hcounter < HSP) HS <= SPP;
		else HS <= ~SPP; 
	end
	
	// Check if between vertical porches,
	// if not send vertical porch synchronization pulse
	always@(posedge pixel_clk)begin
		if(vcounter >= VFP && vcounter < VSP) VS <= SPP;
		else VS <= ~SPP; 
	end
	
	// create a video enabled region
	assign video_enable = (hcounter < HLINES && vcounter < VLINES) ? 1'b1 : 1'b0;

endmodule
