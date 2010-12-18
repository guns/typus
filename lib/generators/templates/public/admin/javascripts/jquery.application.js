/*global jQuery window */

jQuery(document).ready((function($) {
  'use strict';

  // jQuery selector expressions
  var dom = {
    search        : '#quicksearch',
    toggleField   : 'td a[href*=/toggle/]',
    ajaxSelect    : 'form[data-remote=ajax-update] select',
    positionField : 'div[data-remote=ajax-position]'
  },

  // UI constants
  ui = { fadeTime : 400 },

  typus = {
    /*
     * Upstream functions.
     */
    upstream: function() {
      window.unloadMessage = function() {
        return 'You have entered new data on this page. If you navigate away from ' +
                'this page without first saving your data, the changes will be lost.';
      };

      window.setConfirmUnload = function(on) {
        window.onbeforeunload = on ? window.unloadMessage : null;
      };

      $('#quicksearch').searchField();
      $('.resource :input', document.myForm).bind('change', function() { window.setConfirmUnload(true); });
      $('a.fancybox').fancybox({ titlePosition: 'over', type: 'image' });
    },

    /*
     * Onload actions and options setup
     */
    initialize: function() {
      $(dom.search).focus();
      $.ajaxSetup({ dataType: 'json' });
    },

    /*
     * Dynamic boolean toggles
     */
    ajaxToggle: function() {
      $(dom.toggleField).removeAttr('data-confirm').live('click', function() {
        var link  = $(this),
            href  = link.attr('href'),
            field = href.replace(/.*\?.*field=(.*)/, '$1'),
            status;

        $.get(href.replace(/(.*)\?(.*)/, '$1.json?$2'), function(data) {
          for (var key in data) {
            if (data.hasOwnProperty(key)) {
              status = data[key][field] ? 'True' : 'False';
              break;
            }
          }

          link.update(function() { link.html(status); });
        });

        return false;
      });
    },

    /*
     * Dynamic updates via select input fields
     */
    ajaxUpdate: function() {
      $(dom.ajaxSelect).live('change', function() {
        var select = $(this),
            orig   = select.clone(),
            form   = select.parents('form');

        $.ajax({
          url     : form.attr('action'),
          type    : 'POST',
          data    : form.serialize(),
          success : function() { form.update(); },
          error   : function() {
            form.update(function() {
              alert('Error updating "' + form.parent('td').siblings('td.name').html() + '"');
              select.replaceWith(orig);
            });
          }
        });

        return false;
      });
    },

    /*
     * Drag-and-drop dynamic positioning
     */
    dragDropPosition: function() {
      var list     = $(dom.positionField).parents('tbody'),
          getForm  = function(row) { return row.find(dom.positionField + ' form'); },
          getInput = function(row) { return getForm(row).find('input[id$=position]'); },
          getPos   = function(row) { return parseInt(getInput(row).val(), 10); },
          setPos   = function(row, pos) { getInput(row).val(pos); return getForm(row); };

      if (list.children('tr').length < 2) { return false; }

      list.sortable({
        axis    : 'y',
        handle  : dom.positionField,
        opacity : 0.6,
        forcePlaceholderSize : true,

        update: function(event, ui) {
          var idx = list.children('tr').index(ui.item),
              form;

          // determine new position value
          if (idx) {
            form = setPos(ui.item, getPos(ui.item.prev()) + 1);
          } else {
            form = setPos(ui.item, getPos(ui.item.next()));
          }

          // now POST the url
          $.ajax({
            url     : form.attr('action'),
            type    : 'POST',
            data    : { go: getInput(ui.item).val() },
            success : function() {
              form.parents('tr').update(function() {
                // increment positions by one
                form.parents('tr').nextAll('tr').each(function() {
                  var row = $(this);
                  setPos(row, getPos(row) + 1);
                });
              });
            },

            // TODO: restore original order on update!
            error: function() {
              alert('Error updating position of "' + form.parent('td').siblings('td.name').html() + '"');
            }
          });
        }
      });
    }
  };


  /*
   * jQuery extensions.
   */
  $.fn.update = function(callback, fadeTime) {
    this.parent().fadeTo(fadeTime || ui.fadeTime, 0, function() {
      if (typeof callback === 'function') { callback(); }
      $(this).fadeTo(fadeTime || ui.fadeTime, 1);
    });
  };

  // IE hack for ugly font-rendering bug when fading text
  // http://blog.bmn.name/2008/03/jquery-fadeinfadeout-ie-cleartype-glitch/
  $.fn.fadeTo = function(speed, to, callback) {
    return this.animate({ opacity: to }, speed, function() {
      if (to === 1 && $.browser.msie) { this.style.removeAttribute('filter'); }
      if (typeof callback === 'function') { callback.call(this); }
    });
  };


  return function() {
    typus.upstream();
    typus.initialize();
    typus.ajaxToggle();
    typus.ajaxUpdate();
    typus.dragDropPosition();
  };
})(jQuery));
