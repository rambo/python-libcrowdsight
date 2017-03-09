# CrowdSight bindings for Python

<http://sightcorp.com/crowdsight/> An attempt at it anyway, these are very far from usable at the moment.

Using SIP (not the VOIP protocol): <https://www.riverbankcomputing.com/software/sip/intro> because it seemed like the sanest way to handle the C++ -> Python mapping.

OpenCV unfortunately uses completely home-grown bindings-generation
so their code doesn't help me here.

## Building

  - Install the packages in `distro_requirements.txt`
  - run `configure.py`
  - run `make` in the `build` -directory.

That's the theory anyway.
