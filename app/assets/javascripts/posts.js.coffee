$ ->
## Model
  window.Post = Backbone.Model.extend
    urlRoot: '/posts'

## Collections
  window.Posts = Backbone.Collection.extend
    model: Post
    url: '/posts'


## Views
#### Start PostFormView
  window.PostFormView = Backbone.View.extend
    events:
      'submit form': 'save_model'
      
    initialize: () ->
      _.bindAll this, 'render'
      this.posts = this.options.posts
      
    render: () ->
      this.model ?= new Post()
      this.form_header()
      this.template = _.template JST['posts/form'](this.model.toJSON())
      this.$el.html this.template()
      this.editor = new wysihtml5.Editor "body-text",
        toolbar: "toolbar-ta"
        parserRules: wysihtml5ParserRules
      
      this
    
    form_header: () ->
      header = if this.model.isNew() 
      then "Creating a New Blog Post"
      else "Editing #{this.model.get('title')} Post"
      this.model.set { header: header }
      
    save_model: () ->
      attrs =
        title: $('input#title').val()
        preview: $('textarea#preview-text').val()
        body: $('textarea#body-text').val()
        category: $('select#category option:selected').val()
      this.model.save attrs,
        wait: false,
        success: (response) =>
          window.postsSidebar.collection.add response
          window.location = "/#/posts/#{@model.get('id')}"
      false
#### End PostFormView

#### Start NewPageView
  window.NewPostView = PostFormView.extend()
#### End NewPageView

#### Start EditPageView
  window.EditPostView = PostFormView.extend()
#### End EditPageView


#### Start ShowPostView
  window.ShowPostView = Backbone.View.extend
    initialize: () ->
      _.bindAll this, 'render'
      
    render: () ->
      this.template = _.template JST['posts/show'](this.model.toJSON())
      this.$el.html this.template()
      body = this.model.get('body').replace(/<div>/g, "<p>").replace(/<\/div>/g, "</p>")
      this.$('.post-body').html body
      
      this
#### End ShowPageView


#### Start PostsSidebarView
  window.PostsSidebarView = SidebarGroupView.extend
    set_template: () ->
      this.path = 'posts'
      this.template = _.template JST['posts/group']()
#### End PagesSidebarView