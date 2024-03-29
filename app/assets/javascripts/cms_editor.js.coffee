$ ->
## open/close menu
  $('span.menu.icon').click (e) ->
    $span = $(e.target)
    if $span.hasClass 'open'
      $span.removeClass 'open'
    else 
      $span.addClass 'open'
    $span.next().fadeToggle 'fast'
    
#### Start Router
  window.AppRouter = Backbone.Router.extend
    routes:
      # page routes
      'pages/new': 'new_page'
      'pages/:id/edit': 'edit_page'
      'pages/:id': 'show_page'
      'pages/:id/images': 'page_images'
      
      # project routes
      'projects/new': 'new_project'
      'projects/:id/edit': 'edit_project'
      'projects/:id': 'show_project'
      'projects/:id/images': 'project_images'

      # post routes
      'posts/new': 'new_post'
      'posts/:id/edit': 'edit_post'
      'posts/:id': 'show_post'
      'posts/:id/images': 'post_images'
      
      # default
      '*actions': 'default_route'
      

#### Start Sidebar
  window.Sidebar = Backbone.View.extend
    template: _.template JST['shared/sidebar']()
    
    initialize: () ->
      _.bindAll this, 'render'
      this.pages = this.options.pages
      this.projects = this.options.projects
      this.posts = this.options.posts
      
    render: () ->
      this.$el.html this.template()
      this.add_group(this.pages, 'pages')
      this.add_group(this.projects, 'projects')
      this.add_group(this.posts, 'posts')
      this
      
    add_group: (collection, group) ->
      switch group
        when 'pages' 
          window.pagesSidebar = new PagesSidebarView { el: this.$('#pages'), collection: collection }
          pagesSidebar.render().el
        when 'projects' 
          window.projectsSidebar = new ProjectsSidebarView { el: this.$('#projects'), collection: collection }
          projectsSidebar.render().el
        when 'posts' 
          window.postsSidebar = new PostsSidebarView { el: this.$('#posts'), collection: collection }
          postsSidebar.render().el
#### End Sidebar

#### Start SidebarGroupView
  window.SidebarGroupView = Backbone.View.extend
    initialize: () ->
      _.bindAll this, 'render', 'addItem'
      this.collection.bind 'add', this.addItem
      this.set_template()
      
    render: () ->
      this.$el.html this.template()
      this.$('ul').empty() if this.collection.length > 0
      this.addItem item for item in this.collection.models
      this
      
    addItem: (item) ->
      item.set
        to_path: this.path
      item_li = new ItemLIView
        model: item
        collection: this.collection
      this.$('ul').append item_li.render().el
#### End SidebarGroupView

#### Start ItemLIView
  window.ItemLIView = Backbone.View.extend
    tagName: 'li'
    
    initialize: () ->
      _.bindAll this, 'render'
      this.template = _.template JST['shared/group_item_li'](this.model.toJSON())
      
    render: () ->
      this.$el.html this.template()
      this
#### End ItemLIView


$(window).load () ->
#### Router actions
  app_router = new AppRouter
  
  #### START PAGE ROUTES ####
  app_router.on 'route:new_page', (actions) ->
    $.when(add_sidebar()).then () =>
      unless window.new_page?
        window.new_page = new NewPageView
          el: $('#main-content')
          pages: window.pages_collection
      new_page.render().el

  app_router.on 'route:edit_page', (actions) ->
    $.when(add_sidebar()).then () =>
      page = get_page actions
      unless window.edit_page?
        window.edit_page = new EditPageView
          el: $('#main-content')
          model: page
          pages: window.pages_collection
      else
        window.edit_page.model = page 
      edit_page.render().el
      
  app_router.on 'route:show_page', (actions) ->
    $.when(add_sidebar()).then () =>
      page = get_page actions
      unless window.show_page?
        window.show_page = new ShowPageView
          el: $('#main-content')
          model: page
      else
        window.show_page.model = page
      window.show_page.render().el
      
  app_router.on 'route:page_images', (actions) ->
    $.when(add_sidebar()).then () =>
      page = get_page actions
      window.images_index = null if window.images_index?
      window.images_index = new ImageIndex
        el: $('#main-content')
        model: page
        item: 'Page'
      images_index.render().el
   #### END PAGE ROUTES ####


  #### START PROJECT ROUTES ####
  app_router.on 'route:new_project', (actions) ->
    $.when(add_sidebar()).then () =>
      unless window.new_project?
        window.new_project = new NewProjectView
          el: $('#main-content')
          projects: window.projects_collection
      new_project.render().el

  app_router.on 'route:edit_project', (actions) ->
    $.when(add_sidebar()).then () =>
      project = get_project actions
      unless window.edit_project?
        window.edit_project = new EditProjectView
          el: $('#main-content')
          model: project
          projects: window.projects_collection
      else
        window.edit_project.model = project
      edit_project.render().el
      
  app_router.on 'route:show_project', (actions) ->
    $.when(add_sidebar()).then () =>
      project = get_project actions
      unless window.show_project?
        window.show_project = new ShowProjectView
          el: $('#main-content')
          model: project
      else
        window.show_project.model = project
      window.show_project.render().el
      
  app_router.on 'route:project_images', (actions) ->
    $.when(add_sidebar()).then () =>
      project = get_project actions
      window.images_index = null if window.images_index?
      window.images_index = new ImageIndex
        el: $('#main-content')
        model: project
        item: 'Project'
      images_index.render().el
  #### END PROJECT ROUTES ####
  
  
  #### START POST ROUTES ####
  app_router.on 'route:new_post', (actions) ->
    $.when(add_sidebar()).then () =>
      unless window.new_post?
        window.new_post = new NewPostView
          el: $('#main-content')
          posts: window.posts_collection
      new_post.render().el

  app_router.on 'route:edit_post', (actions) ->
    $.when(add_sidebar()).then () =>
      post = get_post actions
      unless window.edit_post?
        window.edit_post = new EditPostView
          el: $('#main-content')
          model: post
          posts: window.posts_collection
      else
        window.edit_post.model = post
      edit_post.render().el
      
  app_router.on 'route:show_post', (actions) ->
    $.when(add_sidebar()).then () =>
      post = get_post actions
      unless window.show_post?
        window.show_post = new ShowPostView
          el: $('#main-content')
          model: post
      else
        window.show_post.model = post
      window.show_post.render().el
      
  app_router.on 'route:post_images', (actions) ->
    $.when(add_sidebar()).then () =>
      post = get_post actions
      window.images_index = null if window.images_index?
      window.images_index = new ImageIndex
        el: $('#main-content')
        model: post
        item: 'Post'
      images_index.render().el
  #### END POST ROUTES ####

  app_router.on 'route:default_route', (actions) ->
    add_sidebar()
  
  Backbone.history.start()
          
add_sidebar = () ->
  $.when(fetch_pages(), fetch_projects(), fetch_posts()).then () ->
    unless window.sidebar?
      window.sidebar = new Sidebar
        el: $('aside')
        pages: window.pages_collection
        projects: window.projects_collection
        posts: window.posts_collection
      sidebar.render().el
        
fetch_pages = () ->
  window.pages_collection = new Pages()
  window.pages_collection.fetch()

fetch_projects = () ->
  window.projects_collection = new Projects()
  window.projects_collection.fetch()

fetch_posts = () ->
  window.posts_collection = new Posts()
  window.posts_collection.fetch()

get_page = (id) -> window.pages_collection.where({id: parseInt(id)})[0]
get_project = (id) -> window.projects_collection.where({id: parseInt(id)})[0]
get_post = (id) -> window.posts_collection.where({id: parseInt(id)})[0]
