%% Research Tools Examples

%% Scrape a Repository Normally

data{1} = ResearchPages( 'tonyfast','Titanium' );

%% Scrape another branch
% Add the ``branch`` option

data{2} = ResearchPages( 'Materials-Informatics-Lab', ...
    'Materials-Informatics-Lab.github.io',...
    'branch', 'master' );

%% Scrape an Older Commit
% Add the ``SHA`` option

data{3} = ResearchPages( 'Materials-Informatics-Lab', ...
    'Materials-Informatics-Lab.github.io',...
    'SHA','9ffdb2b858bef35457cbbd187648c26b4c479450',...
    'branch', 'master' );

%% Only Access Post Data
% Add the ``folders`` option to specify specific folders

data{4} = ResearchPages( 'tonyfast','Titanium', ...
    'folders',{'_posts'});