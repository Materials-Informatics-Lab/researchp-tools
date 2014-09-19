def github( url, service = '' ):
    from urlparse import urlsplit

    if service == 'api':
        data = req_to_pd( url = url, force_json=True )

    elif service =='repo':

        data =  req_to_pd( url = 'https://api.github.com/repos' +\
                                urlsplit( url ).path,
                    force_json=True )
    elif service == 'history':
        parsed = urlsplit( url )
        parts = parsed.path.lstrip('/').split('/')
        for ct, piece in enumerate(parts):
            if piece == 'blob' or piece=='tree':
                break

        repo = ('/').join(parts[0:2])
        sha = parts[ct+1]
        path =  ('/').join(parts[ct+2:])

        data =  req_to_pd( url = 'https://api.github.com/repos/' +\
                                repo + '/commits?path=' + path +\
                                '&sha=' + sha,
                    force_json=True, typ = 'frame', show_url=True )

    elif '/blob/' in url or service =='blob' or service == 'fm':
        import frontmatter
        import urllib2
        url = url.replace( '/blob','')
        parsed = urlsplit( url )
        parsed = parsed._replace(netloc='raw.githubusercontent.com')

        if service == 'fm':
            page = urllib2.urlopen(parsed.geturl())
            data = frontmatter.load(page).metadata
            page.close()
        else:
            data = req_to_pd( parsed.geturl() )

    elif '/commit' in url or service=='noembed':
        data = noembed( url )

    return data

def req_to_pd( url , typ='series', force_json=False, show_url=False, has_fm=False):

    import requests
    import pandas as pd
    import yaml
    from urlparse import urlsplit

    if show_url:
        print url

    parsed = urlsplit( url )
    s = requests.get(  url )

    if parsed.path.endswith('.json') or force_json:
        data = pd.io.json.read_json( s.text, typ = typ )
    elif parsed.path.endswith('.yml') or parsed.path.endswith('.yaml'):
        data = yaml.load( s.text )
    else:
        data = s.text

    return data

def noembed( url ):
    data = req_to_pd( "http://noembed.com/embed?url=" + url, force_json=True )
    return data
