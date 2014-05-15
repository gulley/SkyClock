% Use Steve Eddins's publishing tools to publish directly to blog format.
tools_dir = '\\mathworks\public\Steve_Eddins\matlab\wordpress';
addpath(tools_dir);

script_name = 'calculations';
img_location = 'http://blogs.mathworks.com/community/files/';
img_format = 'png';

% NOTE 1: wordpress_publish is deprecated
% NOTE 2: Be sure and turn off WordPress formatting control.
%         Format this post with No Formatting
%                               No Character Encoding
blogPublish(script_name, img_location, 'imageFormat', img_format);


