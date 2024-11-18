library IEEE;
use IEEE.std_logic_1164.all;

entity calculator is
	port (	clk		: in	std_logic;

		reset_button	: in	std_logic;
		buttons		: in	std_logic_vector (3 downto 0);
		switches	: in	std_logic_vector (8 downto 0);

		display_data	: out	std_logic_vector (7 downto 0);
		display_enable	: out	std_logic_vector (3 downto 0)
	);
end entity calculator;

architecture structural of calculator is

	component display_controller is
		port (	clk			: in	std_logic;	
			reset			: in	std_logic;
			display_data_mux_sel	: out	std_logic_vector (1 downto 0);
			display_enable		: out	std_logic_vector (3 downto 0)
		);
	end component display_controller;

	component adder is
		port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component adder;

	component subtractor is
		port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component subtractor;

	component multiplier is
		port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component multiplier;

	component divider is
		port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component divider;
	
    component and_or is
        port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output_0			: out	std_logic_vector (3 downto 0);
			output_1			: out	std_logic_vector (3 downto 0)
		);
	end component and_or;
		
	component nand_nor is
        port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output_0			: out	std_logic_vector (3 downto 0);
			output_1			: out	std_logic_vector (3 downto 0)
		);
	end component nand_nor;
	
	component xor_xnor is
        port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output_0			: out	std_logic_vector (3 downto 0);
			output_1			: out	std_logic_vector (3 downto 0)
		);
		
	end component xor_xnor;
	
	component comparator is
        port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component comparator;

	component mux_8bit_4input_4sel is
		port (	input_0			: in	std_logic_vector (7 downto 0);
			input_1			: in	std_logic_vector (7 downto 0);
			input_2			: in	std_logic_vector (7 downto 0);
			input_3			: in	std_logic_vector (7 downto 0);
			input_4	: in	std_logic_vector (7 downto 0);
			input_5	: in	std_logic_vector (7 downto 0);
			input_6	: in	std_logic_vector (7 downto 0);
			input_7	: in	std_logic_vector (7 downto 0);
			sel			: in	std_logic_vector (4 downto 0);
			output			: out	std_logic_vector (7 downto 0)
		);
	end component mux_8bit_4input_4sel;

	component mux_4bit_4input is
		port (	input_0			: in	std_logic_vector (3 downto 0);
			input_1			: in	std_logic_vector (3 downto 0);
			input_2			: in	std_logic_vector (3 downto 0);
			input_3			: in	std_logic_vector (3 downto 0);
			sel			: in	std_logic_vector (1 downto 0);
			output			: out	std_logic_vector (3 downto 0)
		);
	end component mux_4bit_4input;

	component output_control is
		port (  input                   : in    std_logic_vector (7 downto 0);
			buttons_valid           : in    std_logic;
			display_data_mux_sel    : in    std_logic_vector (1 downto 0);
			output                  : out   std_logic_vector (7 downto 0)
		);
	end component output_control;

	component bin2seg7 is
		port (	bin			: in	std_logic_vector (3 downto 0);
			seg7			: out	std_logic_vector (7 downto 0)
		);
	end component bin2seg7;

	component buttons_validator is
		port (	buttons			: in	std_logic_vector (3 downto 0);
			buttons_valid		: out	std_logic
		);
	end component buttons_validator;

	signal	digit_left, digit_right		: std_logic_vector (3 downto 0);
	signal  new_ops : std_logic;
	signal	result_add, result_sub		: std_logic_vector (7 downto 0);
	signal	result_mult, result_div		: std_logic_vector (7 downto 0);
	signal result_and, result_or		: std_logic_vector (3 downto 0);
	signal result_nand, result_nor		: std_logic_vector (3 downto 0);
	signal result_xor, result_xnor		: std_logic_vector (3 downto 0);
	signal	result_andor, result_nandnor	: std_logic_vector (7 downto 0);
	signal	result_xorxnor, result_compare	: std_logic_vector (7 downto 0);
	signal	extra_and_buttons		: std_logic_vector (4 downto 0);
	signal	calculation_result		: std_logic_vector (7 downto 0);
	signal	display_data_mux_sel		: std_logic_vector (1 downto 0);
	signal	bin_display_data		: std_logic_vector (3 downto 0);
	signal	seg7_display_data		: std_logic_vector (7 downto 0);
	signal	buttons_valid			: std_logic;

begin
    new_ops <= switches(8); -- new_ops = 1 -> logic operators, new_ops = 0 -> arithmetic operators
	digit_left	<= switches (7 downto 4);
	digit_right	<= switches (3 downto 0);
	extra_and_buttons <= new_ops & buttons; -- [opgroup, op1, op2, op3, op4]

	result_andor <= result_and & result_or;
	result_nandnor	<= result_nand & result_nor;
	result_xorxnor	<= result_xor & result_xnor;
-- result_compare is good as it is

lbl_adder:
	adder		port map (	input_0			=> digit_left,
					input_1			=> digit_right,
					output			=> result_add
			);

lbl_subtractor:
	subtractor	port map (	input_0			=> digit_left,
					input_1			=> digit_right,
					output			=> result_sub
			);

lbl_multiplier:
	multiplier	port map (	input_0			=> digit_left,
					input_1			=> digit_right,
					output			=> result_mult
			);

lbl_divider:
	divider		port map (	input_0			=> digit_left,
					input_1			=> digit_right,
					output			=> result_div
			);

lbl_and_or:
	and_or		port map (	input_0 			=> digit_left,
						input_1		=> digit_right,
						output_0	=> result_and,
						output_1	=> result_or
			);

lbl_nand_nor:
	nand_nor	port map (	input_0			=> digit_left,
						input_1		=> digit_right,
						output_0	=> result_nand,
						output_1	=> result_nor
			);

lbl_xor_xnor:
	xor_xnor	port map (	input_0			=> digit_left,
						input_1		=> digit_right,
						output_0	=> result_xor,
						output_1	=> result_xnor
			);

lbl_comparator:
	comparator	port map (	input_0			=> digit_left,
						input_1		=> digit_right,
						output		=> result_compare
			);

lbl_mux_8bit_4input_4sel:
	mux_8bit_4input_4sel port map (	input_0			=> result_add,
					input_1			=> result_sub,
					input_2			=> result_mult,
					input_3			=> result_div,
					input_4		=> result_andor,
					input_5		=> result_nandnor,
					input_6		=> result_xorxnor,
					input_7		=> result_compare,
					sel			=> extra_and_buttons,
					output			=> calculation_result
			);

lbl_display_controller:
	display_controller port map (	clk			=> clk,	
					reset			=> reset_button,
					display_data_mux_sel	=> display_data_mux_sel,
					display_enable		=> display_enable
			);
	
lbl_mux_4bit_4input:
	mux_4bit_4input	port map (	input_0			=> digit_left,
					input_1			=> digit_right,
					input_2			=> calculation_result (7 downto 4),
					input_3			=> calculation_result (3 downto 0),
					sel			=> display_data_mux_sel,
					output			=> bin_display_data
			);

lbl_bin2seg7:
	bin2seg7	port map (	bin			=> bin_display_data,
					seg7			=> seg7_display_data
			);

lbl_buttons_validator:
	buttons_validator port map (	buttons			=> buttons,
					buttons_valid		=> buttons_valid
			);

lbl_output_control:
	output_control	port map (	input			=> seg7_display_data,
					buttons_valid		=> buttons_valid,
					display_data_mux_sel	=> display_data_mux_sel,
					output			=> display_data
			);

end architecture structural;
