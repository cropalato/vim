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
