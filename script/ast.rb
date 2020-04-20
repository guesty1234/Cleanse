#!/usr/bin/env ruby

require 'pathname'

DISALLOWED_ARGUMENTS = {
    '-emit-dependencies' => :none,
    '-emit-module' => :none,
    '-emit-module-path' => :arg,
    '-emit-objc-header' => :none,
    '-emit-objc-header-path' => :arg,
    '-c' => :none,
    '-incremental' => :none,
    '-parseable-output' => :none
}

def swiftc_executable
    Pathname.new(ENV['DEVELOPER_DIR']).join('Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc')
end

def strip_disallowed_arguments(disallowed_args, input)
    input.each_index.select do |idx|
    	disallowed_args.key?(input[idx])
    end
end


def main
	input = ARGV
	og_command = [swiftc_executable] + input
	ast_input = input.clone
	indices_to_remove = strip_disallowed_arguments(DISALLOWED_ARGUMENTS, ast_input).flat_map do |idx|
		if DISALLOWED_ARGUMENTS[input[idx]] == :arg
			[idx, idx+1]
		else
			[idx]
		end
	end

	indices_to_remove.sort.reverse.each do |idx|
		ast_input.delete_at(idx)
	end

	dump_ast_command = [swiftc_executable] + ['-dump-ast'] + ast_input
	combined_command = og_command + ['&&'] + dump_ast_command
	puts dump_ast_command.join(" ")
	system(combined_command.join(" "))
end

main
