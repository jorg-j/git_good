# git_good

Bash tool for making git a little easier.

Clone this repo and copy the git_good.sh file into your project.

Open git bash at your project location.

Type `./git_good.sh -h` for a help menu.

## Basic use

Some options will have prompts and guides to support you through.

  To declare the filename -f | --file filename

  To declare the commit message -c | --commit | -m 'My message'

  Unstage a file -u | --unstage filename (File is added but not commited)

  Create a branch wizard -b |--branch

  Setup an entire repo structure -B | --build (new projects only)

  See commit history -C | --commits

  Push and pull commits -p | --sync

  Merge helper -M | --merge

  Update -U | --update

Add a file and commit message in 1 line
`./git_good.sh -f myfile.txt -m "init new file"`

Note: first run should be done in the cloned directory. `./git_good.sh`
Once this is done running --update will update git_good to the latest version in your local repo and will update the file in your local project. In this way you can upgrade git_good on the current project without leaving the directory.


## Contributing

This is a living project. Feel free to fork this code to suit you or add to it for new features.
Alternatively if there is something you would like added please reach out

## Authors and acknowledgment

- jorg-j

## License

Copyright 2022 jorg-j

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

