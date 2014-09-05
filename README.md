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

In order to access all of the 

### Research Pages Options

* ``branch`` - Change the branch that is accessing the files.  ``gh-pages`` is the default; if the repository is a Github Pages username domain then the branch needs to be explicitly defined as ``master``.  Any branch can be accessed as long as it exists.
* ``SHA`` - Access Github pages information from a prior commit
* ``folders`` - this function scrapes information from the ``_data`` and ``_posts`` folder on Jekyll pages.  Folders can be added and removed as an optional argument.  This is useful when extending [Jekyll Collections](jekyllrb.com/docs/collections/)

### ``.ghcred`` for Authentication
