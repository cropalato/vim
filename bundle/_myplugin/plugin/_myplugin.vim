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
function EyamlEncrypt() range
  " Yank current or last selection to register x
  normal! gv"xy

  let append = ""
  let num_sel_lines = line("'>") - line("'<") + 1
  if num_sel_lines > 5
      let shellcmd = 'eyaml encrypt -o block --stdin 2> /dev/null'
      let append = ">\n"
  else
    let shellcmd = 'eyaml encrypt -o string --stdin 2> /dev/null'
  endif
  if strridx(@x,'ENC[') > -1
      let shellcmd = 'eyaml decrypt --stdin 2> /dev/null'
      let append = ""
  endif
  let output=system(shellcmd, @x)
  " strip newlines from output and put in register x
  let new_output = substitute(output, '[\r\n]*$', '', '')
  let @x = append . new_output
  "re-select area and paste register x
  normal! gv"xp
endfunction

map <Leader>e :call EyamlEncrypt() <CR>

function PrintJson()
  " get last selected area
  normal! gv"xy

  let shellcmd = 'python -m json.tool'
  let output=system(shellcmd, @x)
  let @x=output
  normal! gv"xp
endfunction

map <Leader>p :call PrintJson() <CR>

