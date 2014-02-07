fernet-cli
==========

Now, the power of [Fernet](https://github.com/fernet/spec) is
available from the shell!

```
tmaher@og-kush:~$ fernet-encrypt --help
Usage: fernet-encrypt [-p | -k <keyfile>] -i <infile> -o <outfile>
    -p, --prompt                     Prompt for keys
    -k, --keyfile KEYFILE
    -i, --infile INPUTFILE
    -o, --outfile OUTPUTFILE
```

And there's a corresponding `fernet-decrypt` too.  The key should be a
base64-encoded blob of 256-bits.  If you'd rather not write it out to
a file or get promted for it, you can save it to shell environment
variable `FERNET_CLI_KEY`.

For `fernet-encrypt`, the infile is plaintext and the outfile is
ciphertext.  For `fernet-decrypt`, the infile is ciphertext and the
outfile is plaintext.  

For more information, see https://github.com/fernet/spec
