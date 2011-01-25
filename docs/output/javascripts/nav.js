function create_menu(basepath)
{

	document.write(

		'<table cellpadding="0" cellspaceing="0" border="0" style="width:98%"><tr>' +
		'<td class="td" valign="top">' +

		'<h3>Overview</h3>' +
		'<ul>' +
		'<li><a href="/overview/getting-started/">Getting Started</a></li>' +
		'<li><a href="/overview/typus-at-a-glance/">Typus at a Glance</a></li>' +
		'<li><a href="/overview/supported-features/">Supported Features</a></li>' +
		'<li><a href="/overview/architectural-goals/">Architectural Goals</a></li>' +
		'</ul>' +

		'<h3>Basic Info</h3>' +
		'<ul>' +
		'<li><a href="/requirements/">Requirements</a></li>' +
		'<li><a href="/mit-license/">MIT License</a></li>' +
		'<li><a href="/change-log/">Change Log</a></li>' +
		'<li><a href="/credits/">Credits</a></li>' +
		'</ul>' +

		'</td><td class="td_sep" valign="top">' +

		'<h3>Installation</h3>' +
		'<ul>' +
		'<li><a href="/installation/instructions/">Instructions</a></li>' +
		'<li><a href="/installation/generators/">Generators</a></li>' +
		'<li><a href="/installation/rake-tasks/">Rake Tasks</a></li>' +
		'<li><a href="/installation/upgrading/">Upgrading</a></li>' +
		'<li><a href="/installation/troubleshooting/">Troubleshooting</a></li>' +
		'</ul>' +

		'<h3>Configuration</h3>' +
		'<ul>' +
		'<li><a href="/configuration/initializers/">Initializers</a></li>' +
		'<li><a href="/configuration/resources/">Resources</a></li>' +
		'<li><a href="/configuration/resource/">Resource</a></li>' +
		'<li><a href="/configuration/roles/">Roles</a></li>' +
		'</ul>' +

		'</td><td class="td_sep" valign="top">' +

		'<h3>Customization</h3>' +
		'<ul>' +
		'<li><a href="/customization/user-interface/">User Interface</a></li>' +
		'<li><a href="/customization/attribute-templates/">Attribute Templates</a></li>' +
		'</ul>' +

		'<h3>Recipes</h3>' +
		'<ul>' +
		'<li><a href="/recipes/rich-text-editor/">Adding a Rich Text Editor</a></li>' +
		'<li><a href="/recipes/custom-actions/">Custom Actions</a></li>' +
		'<li><a href="/recipes/single-table-inheritance/">Single Table Inheritance</a></li>' +
		'<li><a href="/recipes/namespaced-models/">Namespaced Models</a></li>' +
		'<li><a href="/recipes/configuration-files/">Configuration Files</a></li>' +
		'<li><a href="/recipes/testing-the-plugin/">Testing the Plugin</a></li>' +
		'</ul>' +

		'</td><td class="td_sep" valign="top">' +

		'<h3>Additional Resources</h3>' +
		'<ul>' +
		'<li><a href="/desmond.rb">Application Template</a></li>' +
		'<li><a href="http://demo.typuscms.com/">Application Demo</a></li>' +
		'<li><a href="http://rubygems.org/gems/typus">Gems</a></li>' +
		'<li><a href="http://github.com/fesplugas/typus">Plugin Source Code</a></li>' +
		'<li><a href="http://groups.google.com/group/typus">Mailing List</a></li>' +
		'<li><a href="http://github.com/fesplugas/typus/issues">Bug reports</a></li>' +
		'<li><a href="http://github.com/fesplugas/typus/contributors">Contributors List</a></li>' +
		'<li><a href="http://pledgie.com/campaigns/11233">Donate</a></li>' +
		'<li><a href="http://ruby-toolbox.com/categories/rails_admin_interfaces.html">Ruby Toolbox</a></li>' +
		'</ul>' +

		'<h3>Elsewhere</h3>' +
		'<ul>' +
		'<li><a href="http://www.joshcrews.com/2010/03/using-heroku-to-host-your-rails-cms/">Using Heroku to host your Rails CMS</a></li>' +
		'</ul>' +

		'</td></tr></table>');

}
