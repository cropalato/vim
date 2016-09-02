let g:templates_user_variables = [
            \   ['PUPPETCLASS', 'GetPuppetNamespace'],
            \ ]

function! GetPuppetNamespace()
    let name = expand('%:t:r')
    let init_file = 0
    if name == "init"
        let init_file = 1
    endif
    if expand('%:p') =~ "/manifests"
        let path = split(expand('%:p:h'), "/")
        let i = len(path) - 1
        while i > 0
            if path[i] == "manifests"
                let name = join([path[i-1], name], "::")
                break
            else
                let name = join([path[i], name],"::")
            endif
            let i -= 1
        endwhile
    endif
    if init_file == 1
        if name !~ ".*::.*::init"
            return split(name,"::")[0]
        endif
    else
        return name
    endif
endfunction


"eyaml section (forked from https://github.com/takeaway-com/vim-eyaml-encrypt)
function EyamlEncrypt()
  " Yank current or last selection to register x
  normal! gv"xy

  let shellcmd = 'eyaml encrypt --stdin 2>&1| grep "^string"  | cut -d" " -f2'
  let output=system(shellcmd, @x)
  " strip newlines from output and put in register x
  let @x = substitute(output, '[\r\n]*$', '', '')
  "re-select area and paste register x
  normal! gv"xp
endfunction

map <Leader>e :call EyamlEncrypt() <CR>
