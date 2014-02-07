require 'fernet'
require 'optparse'
require 'highline/import'

module Fernet
  class CLI
    def initialize
      @options = {}
      @op_obj = parse_args
      @key = get_key
      (@in_fd, @out_fd) = set_file_descriptors
    end

    def abort msg="unspecified error"
      $stderr.puts "FAIL: #{msg}", @op_obj.banner, @op_obj.summarize
      exit(1)
    end
    
    def parse_args
      op = OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} [-p | -k <keyfile>] -i <infile> -o <outfile>"

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          @options[:verbose] = v
        end
        opts.on("-p", "--prompt", "Prompt for keys") do |prompt|
          @options[:prompt] = prompt
        end
        opts.on("-k", "--keyfile KEYFILE") do |keyfile|
          @options[:keyfile] = keyfile
        end
        opts.on("-i", "--infile INPUTFILE") do |infile|
          @options[:infile] = infile
        end
        opts.on("-o", "--outfile OUTPUTFILE") do |outfile|
          @options[:outfile] = outfile
        end
        opts.on("--enforce-ttl") do |ttl|
          options[:ttl] = true
        end
      end
      op.parse!
      op
    end

    def get_key
      if ENV["FERNET_CLI_KEY"].nil?
        if @options[:prompt]
          key = ask("Enter Key: ") {|q| q.echo = false}
        elsif @options[:keyfile]
          key = File.read(@options[:keyfile])
        end
      else
        key=ENV["FERNET_CLI_KEY"]
      end

      abort("please specify a key") if key.nil?

      key.chomp
    end

    def set_file_descriptors
      if @options[:infile].nil? or @options[:outfile].nil?
        abort "must specify input & output files. Use '-' for stdin/stdout"
      end

      if @options[:infile] == "-"
        in_fd = $stdin
      else
        abort("can't read input file") unless File.readable?(@options[:infile])
        in_fd = File.open(@options[:infile])
      end

      if @options[:outfile] == "-"
        out_fd = $stdout
      else
        out_fd = File.open(@options[:outfile], "w+")
      end

      [in_fd, out_fd]
    end
    
    def encrypt
      @out_fd.write(Fernet.generate(@key, @in_fd.read))
      @out_fd.close
    end

    def decrypt
      plaintext = Fernet.verifier(@key, @in_fd.read,
                                  enforce_ttl: @options[:ttl])
      abort("ciphertext corrupt") unless plaintext.valid?
      
      @out_fd.write(plaintext.message)
      @out_fd.close
    end
    
  end
end
