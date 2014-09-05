# researchp-tools

This repository hosts utilities to collaborate on [Github pages designed for research science](https://github.com/Materials-Informatics-Lab/research-pages).

Github Research pages host ``_data`` and ``_posts`` corresponding to scientifici research.  Both folders contain serialized ``YAML`` or ``JSON`` 
to write posts, share infromation, and present research findings.  The tools in this repository assist in accessing
YAML, JSON, and YAML front-matter to a local computing environment.  **Currently, this only works for Matlab.**

# ``matlab`` branch

The ``matlab`` branch contains matlab specific codes to access Github pages locally.  The has the following requirements install:

* [JSONlab](www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files-in-matlab-octave)
* [Matlab YAML](http://code.google.com/p/yamlmatlab/)

## Clone ``matlab`` utilities

Clone the Matlab tools with the following command

```
git clone -b matlab https://github.com/Materials-Informatics-Lab/researchp-tools.git
```

## Accessing De-serialized Content Locally

``ResearchPages`` is a matlab function to access Github pages content.  

> See [``example.m``](https://github.com/Materials-Informatics-Lab/researchp-tools/blob/matlab/example.m) for usage.

### Research Pages Options

* ``branch`` - Change the branch that is accessing the files.  ``gh-pages`` is the default; if the repository is a Github Pages username domain then the branch needs to be explicitly defined as ``master``.  Any branch can be accessed as long as it exists.
* ``SHA`` - Access Github pages information from a prior commit
* ``folders`` - this function scrapes information from the ``_data`` and ``_posts`` folder on Jekyll pages.  Folders can be added and removed as an optional argument.  This is useful when extending [Jekyll Collections](jekyllrb.com/docs/collections/)

### ``.ghcred`` for Authentication

Github limits the number of unauthenticated calls that can be made to the API (60 requests/ hour ).  5000 requests/hour can be made with [authenticated requests](https://developer.github.com/v3/#increasing-the-unauthenticated-rate-limit-for-oauth-applications).

To make autheticated requests:

1. Request a Github Developer Application for this function to get an API and secret key.
2. Make a new file called ``.ghauth``
3. Modify ``xxxx`` and ``yyyy`` string and at it to ``.ghauth``

```
?client_id=xxxx&client_secret=yyyy
```


> See more a [Github Developer](https://developer.github.com/v3/#rate-limiting)
