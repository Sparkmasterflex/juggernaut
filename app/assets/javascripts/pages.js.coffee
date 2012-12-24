$ ->
## Model
  window.Page = Backbone.Model.extend
    urlRoot: '/pages'

## Collections
  window.Pages = Backbone.Collection.extend
    model: Page
    url: '/pages'
    
  
## Views
#### Start PageFormView
  window.PageFormView = Backbone.View.extend
    events:
      'blur input#title': 'create_path'
      'submit form': 'save_model'
    
    initialize: () ->
      _.bindAll this, 'render'
      this.pages = this.options.pages
      
    render: () ->
      this.model ?= new Page()
      this.form_header()
      this.template = _.template JST['pages/form'](this.model.toJSON())
      this.$el.html this.template()
      this.editor = new wysihtml5.Editor "body-text",
        toolbar: "toolbar-ta"
        parserRules: wysihtml5ParserRules
      
      this
    
    form_header: () ->
      header = if this.model.isNew() 
      then "Creating a New Page"
      else "Editing #{this.model.get('title')} Page"
      this.model.set { header: header }
      
    save_model: () ->
      attrs =
        title: $('input#title').val()
        path: $('input#path').val()
        preview: $('textarea#preview-text').val()
        body: $('textarea#body-text').val()
      this.model.save attrs,
        wait: false,
        success: (response) =>
          window.pagesSidebar.collection.add response
          window.location = "/#/pages/#{@model.get('id')}"
          
      false
      
    create_path: (e) ->
      title = $(e.target).val()
      $path = this.$('input#path')
      
      path = title.toLowerCase().replace(/[\s\W_]/g, '-')
      $path.val path
      false

#### End PageFormView
      
#### Start NewPageView
  window.NewPageView = PageFormView.extend()
#### End NewPageView

#### Start EditPageView
  window.EditPageView = PageFormView.extend()
#### End EditPageView

#### Start ShowPageView
  window.ShowPageView = Backbone.View.extend
    initialize: () ->
      _.bindAll this, 'render'
      
    render: () ->
      this.template = _.template JST['pages/show'](this.model.toJSON())
      this.$el.html this.template()
      body = this.model.get('body').replace(/<div>/g, "<p>").replace(/<\/div>/g, "</p>")
      this.$('.page-body').html body
      
      this
#### End ShowPageView

#### Start PagesSidebarView
  window.PagesSidebarView = SidebarGroupView.extend
    set_template: () ->
      this.path = 'pages'
      this.template = _.template JST['pages/group']()
#### End PagesSidebarView

