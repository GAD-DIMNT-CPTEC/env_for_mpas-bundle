## env_for_mpas-bundle

### Readme

Environment to build JEDI mpas-bundle release 2.0.0 or develop at CPTEC's EGEON cluster

The step by step to build JEDI mpas-bundle (release 2.0.0 or develop) at CPTEC's EGEON cluster using libraries builded with GNU9 compiler.

This mpas-bundle release can be downloaded from JCSDA git repository ( https://github.com/JCSDA/mpas-bundle ) with the command:

```
git clone -b release/2.0.0 https://github.com/JCSDA/mpas-bundle.git  mpas-bundle-rel2.0.0     # **for release/2.0.0**
source How_to_build_mpas-bundle-2.0.0.sh 
```
or

``` 
git clone -b develop https://github.com/JCSDA/mpas-bundle.git  mpas-bundle-dev    # **for develop branch**
source How_to_build_mpas-bundle-develop.sh 
```
### Libraries needed : 

The libraries needed to build mpas-bundle were built with jedi-stack (https://github.com/JCSDA/jedi-stack) with adustments of versions (required for release 2.0.0 or develop branch of mpas-bundle) and others sets needed at EGEON cluster.
