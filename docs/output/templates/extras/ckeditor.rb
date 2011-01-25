##
# You can apply this template to your existing project by running:
#
#     $ rake rails:template LOCATION=http://core.typuscms.com/templates/extras/ckeditor.rb
#

run <<-CMD
mkdir -p public/vendor
cd public/vendor
curl -s -O http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5/ckeditor_3.5.tar.gz
tar xvzf ckeditor_3.5.tar.gz
rm ckeditor_3.5.tar.gz
CMD

run 'rm public/admin/javascripts/application.js'
file 'public/admin/javascripts/application.js', <<-END
document.write("<script type='text/javascript' src='/vendor/ckeditor/ckeditor.js'></script>"); 

$(function() {
  if ($('textarea').length > 0) {
    var data = $('textarea');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }
});
END

run 'rm public/vendor/ckeditor/config.js'
file 'public/vendor/ckeditor/config.js', <<-END
/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{

  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';

  config.height = '250px';
  config.width = '690px';

  config.toolbar = 'Easy';
  config.toolbar_Easy =
    [
        ['Source','-','Templates', '-', 'Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Maximize'],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Link','Unlink','Anchor', '-', 'Image','Embed'],
        ['Styles','Format', 'Bold','Italic','Underline','Strike','-', 'TextColor'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ];

};
END
