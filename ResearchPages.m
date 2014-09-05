function data = ResearchPages( username, reponame, varargin )
% A function to access research information from Github Pages
% Requires:
% JSONlab
%
% 'SHA' - access information from a different version
% 'folders' - ``gh-pages`` directories to access
%
% .ghauth file

%% Github API Requests

addpath('./jsonlab/')
addpath('./yaml/')

GH = setparam( username, reponame, varargin{:} );

% Add API Authorization if necessary
if exist( '.ghcred', 'file')
    fo = fopen('.ghcred','r');
    GH.AUTH = fscanf(fo, '%s');
    fclose(fo);
end

%% Check for Github Pages branch
% If successful, return the current SHA.

if isempty( GH.SHA )
    branchinfo= MakeRequest(horzcat('branches/', GH.branch));
    GH.SHA = branchinfo.commit.sha;
end


%%
pagesinfo= MakeRequest(horzcat('git/trees/', GH.SHA ) );

folder_id = find( ...
    cellfun( ...
    @(x)ismember(getfield( x, 'path'), GH.folders), ...
    pagesinfo.tree) );


ct_id = 0;



for id = folder_id
    ct_id = ct_id + 1;
    folder_sha = pagesinfo.tree{id}.sha;
    folder_contents = MakeRequest(horzcat('git/trees/', folder_sha ) );
    ct_ff = 0;
    
    folderfield = pagesinfo.tree{id}.path;
    if folderfield(1) == '_' folderfield(1) = []; end
    
    for ff = 1 : numel( folder_contents.tree )    
        ct_ff = ct_ff + 1;
        lcl_path = horzcat( pagesinfo.tree{id}.path, ...
            '/', folder_contents.tree{ff}.path );
        
        disp( sprintf('Loading: %s',lcl_path) );
        data.(folderfield){ct_ff} = GetRaw( lcl_path );
        data.(folderfield){ct_ff}.path = lcl_path ;
        
    end
end


end %ResearchPages

function [data] = MakeRequest( req )
% Make the request and de-serialize the JSON
% Error handling embedded

request_url = horzcat( evalin('caller','GH.CALL'), ...
    req );

% Remove trailing slash to complete request if it exists.
if request_url(end)=='/' request_url(end) = []; end

% Make signed called if the auth is avaiable.
request_url = horzcat( request_url, evalin('caller','GH.AUTH'));

% Make Request
[ s status] = urlread( request_url );

if status
    data = loadjson( s );
else
    error( ...
        sprintf( 'The request to "%s" was not valid.', ...
        request_url ) )
end % if status



end %MakeRequest

%%
function [data] = GetRaw( path )
% Make the request and de-serialize the JSON
% Error handling embedded
% If it is YAML,HTML, or MD then I use a Yaml interpreter and urlwrite

file_ext = fliplr( strtok( fliplr( path ),'.'));

types = {'json','yaml','yml','html','md','markdown'};
ext_type = find( strcmpi(file_ext,types) ); 


request_url = horzcat( evalin('caller','GH.RAW'), ...
    path );

if ext_type == 1
% Process JSON request

    [ jsonreq status] = urlread( request_url );
    
    data = loadjson( jsonreq );
elseif ext_type > 1
    % Process YAML
    [ filestr status] = urlwrite( request_url, tempname );
    if ismember( ext_type, [2 3] );
    else % Remove Front Matter
        fo = fopen( filestr ,'r+');
        [docct ,ct] = deal( 0 ); 
        while docct<2 & ~feof(fo)
            
            s = fgetl( fo );
            if ~isempty(s) & all( s == '-' );
                docct = docct + 1;
            elseif ~isempty(s)
                ct = ct + 1;
                outstr{ct} = s;
            end
        end
        fclose(fo); 
        
        fo = fopen( filestr, 'w');
        fprintf( fo,'%s\n', outstr{:} );
        fclose(fo);
    end
    data = ReadYaml( filestr );
    delete( filestr );
else
end

if status
else
    error( ...
        sprintf( 'The request to "%s" was not valid.', ...
        request_url ) );
end % if status

end % GetRaw

%% 

function GH = setparam( username, reponame, varargin )

GH = struct( 'AUTH', '', ...
    'REQUEST', 'https://api.github.com/repos/', ...
    'username', username, ...
    'repo', reponame, ...
    'SHA', '', ...
    'branch','gh-pages',...
    'folders', {{'_data','_posts'}});

GH.CALL = horzcat( GH.REQUEST, GH.username, '/', GH.repo,'/' );
GH.RAW = horzcat( 'https://raw.githubusercontent.com/', ...
    GH.username, '/', GH.repo,'/gh-pages/' );

if ~isempty( varargin )
    for ii = 1 : 2 : numel(varargin )
        GH = setfield( GH, varargin{ii}, varargin{ii+1} );
    end
end

GH.CALL = horzcat( GH.REQUEST, GH.username, '/', GH.repo,'/' );
GH.RAW = horzcat( 'https://raw.githubusercontent.com/', ...
    GH.username, '/', GH.repo,'/',GH.branch,'/' );

end % setparam