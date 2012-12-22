$ ->
## Model
  window.Project = Backbone.Model.extend
    urlRoot: '/projects'
    
## Collections
  window.Projects = Backbone.Collection.extend
    model: Project
    url: '/projects'
    
## Views
#### Start ProjectFormView
  window.ProjectFormView = Backbone.View.extend
    events:
      'submit form': 'save_model'
      'keypress #tech-field': 'tag_technology'
      'click a.delete': 'remove_technology'
      
    initialize: () ->
      _.bindAll this, 'render'
      this.projects = this.options.projects
      
    render: () ->
      this.model ?= new Project()
      this.form_header()
      this.template = _.template JST['projects/form'](this.model.toJSON())
      this.$el.html this.template()
      this.editor = new wysihtml5.Editor "body-text",
        toolbar: "toolbar-ta"
        parserRules: wysihtml5ParserRules
      _.each this.$('#progress option'), (option) =>
        $(option).attr('selected', true) if parseInt($(option).val()) is this.model.get('progress')
      this.add_tech_tags()
      this
      
    form_header: () ->
      header = if this.model.isNew() 
      then "Creating a New Project"
      else "Editing #{this.model.get('title')} Project"
      this.model.set { header: header }
      
    save_model: (e) ->
      attrs =
        title: $('input#title').val()
        body: $('textarea#body-text').val()
        progress: $('select#progress option:selected').val()
        client: $('input#client').val()
        start_date: $('input#start-date').val()
        technology: $('input#technology').val()
        
      this.model.save attrs,
        wait: false,
        success: (response) =>
          window.projectsSidebar.collection.add response
          window.location = "/#/projects/#{@model.get('id')}"
      
      false
      
    add_tech_tags: () ->
      if this.model.get('technology')? and this.model.get('technology') isnt ""
        technologies = this.model.get('technology').split '|'
        this.$('#tech-field').after "<ul class='tech tags'></ul>"
        _.each technologies, (tech) =>
          @.$('ul.tech').append "<li><span>#{tech}</span><a href='#remove' data-tech='#{tech}' class='delete icon'>remove</a></li>" if tech? and tech isnt ""
      
    tag_technology: (e) ->
      $tech = $(e.target)
      $hidden = this.$('#technology')
      if e.which is 13
        e.preventDefault()
        value = if $hidden.val() is "" then $tech.val() else "#{$hidden.val()}|#{$tech.val()}"
        $hidden.val value
        $tech.after "<ul class='tech tags'></ul>" unless this.$('ul.tech').length > 0
        $li = $("<li><span>#{$tech.val()}</span><a href='#remove' data-tech='#{$tech.val()}' class='delete icon'>remove</a></li>")
        this.$('ul.tech').append $li
        $tech.val("")
        
    remove_technology: (e) ->
      $link = $(e.target)
      $li = $link.parents('li')
      $hidden = this.$('#technology')
      remove = $link.data('tech')
      $li.fadeOut 'fast', () => 
        $li.remove()
        hidden_val = $hidden.val().replace(new RegExp("(|\\|)#{remove}"), '')
        $hidden.val hidden_val
      
      false
      
#### End ProjectFormView

#### Start NewPageView
  window.NewProjectView = ProjectFormView.extend()
#### End NewPageView

#### Start EditPageView
  window.EditProjectView = ProjectFormView.extend()
#### End EditPageView

#### Start ProjectsSidebarView
  window.ProjectsSidebarView = SidebarGroupView.extend
    set_template: () ->
      this.path = 'projects'
      this.template = _.template JST['projects/group']()
#### End ProjectsSidebarView

#### Start ShowProjectView
  window.ShowProjectView = Backbone.View.extend
    initialize: () ->
      _.bindAll this, 'render'
      
    render: () ->
      this.template = _.template JST['projects/show'](this.model.toJSON())
      this.$el.html this.template()
      body = this.model.get('body').replace(/<div>/g, "<p>").replace(/<\/div>/g, "</p>")
      this.$('.project-body').html body
      
      this
#### End ShowProjectView
