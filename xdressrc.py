#!/usr/bin/env xdress
package = 'crowdsight'     # top-level python package name
packagedir = 'crowdsight'  # location of the python package

stlcontainers = [
    ('vector', 'int'),
    ('vector', 'float'),
    ('vector', ('vector', 'int')),
#    'cv::Point',
#    'cv::Mat',
#    'cv::Rect',
#    ('vector', 'cv::Point'),
#    ('vector', 'cv::Rect'),
]

# will be used later, but need to be present now
classes = [
    ('*', '/usr/include/crowdsight.h'),
]
functions = []
