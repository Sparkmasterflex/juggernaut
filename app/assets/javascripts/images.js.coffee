$ ->
  window.Image = Backbone.Model.extend
    urlRoot: '/images'
    
    title: () -> this.model.get 'title'
    caption: () -> this.model.get 'caption'
    klass: () -> this.model.get 'klass'

  window.Images = Backbone.Collection.extend
    url: '/images'
    model: Image
    
    initialize: (options) ->
      if options.attachable_type?
        this.url += "?attachable_type=#{options.attachable_type}&attachable_id=#{options.attachable_id}"
    
  window.ImageIndex = Backbone.View.extend
    initialize: () ->
      _.bindAll this, 'render', 'render_images'
      this.model.set 'klass', this.options.item
      this.template = _.template JST['images/index'](this.model.toJSON())
      
    render: () ->
      this.$el.html this.template()
      this.render_image_form()
      
      this.images = new Images
        attachable_id: this.model.get('id')
        attachable_type: this.model.get('klass')
      this.images.fetch
        success: () => @render_images()
      this
    
    render_image_form: () ->
      window.imageForm = new ImageForm
        el: this.$('.col.left')
        model: new Image {parent_id: this.model.get('id'), klass: this.model.get('klass')}
        images: this.images
      imageForm.render().el
    
    render_images: () ->
      window.imagesView = new ImagesView
        el: this.$('.col.right')
        collection: this.images
      imagesView.render().el

    
  window.ImageForm = Backbone.View.extend
    events:
      "click input[type=submit]": 'save_model'
      
    initialize: () ->
      _.bindAll this, 'render', 'fetch_images'
      this.images = this.options.images
      this.template = _.template JST['images/form'](this.model.toJSON())
      
    render: () ->
      this.$el.html this.template()
      this

    save_model: (e) ->
      $.ajax
        url: "/validate/8ca6fcbf1876f29da54c8e6a0c3e4238"
        type: 'GET'
        dataType: 'json'
        success: (data) =>
          auth_token = "<input type='hidden' name='authenticity_token' value='#{data['token']}' />"
          form = @.$('form')
          form.prepend auth_token
          form.submit()
          @.$('form').html "<span class='spinner clearfix'>Loading...</span>"
          setTimeout @fetch_images, 2000
          
      false
  
    fetch_images: () ->
      this.render()
      this.images.fetch()


  window.ImagesView = Backbone.View.extend
    template: _.template JST['images/list']()
    
    initialize: () ->
      _.bindAll this, 'render'
      this.collection.bind 'reset', this.render
      
    render: () ->
      this.$el.html this.template()
      this.$('ul.list').empty() unless this.collection.length is 0
      this.render_image_li image for image in this.collection.models
      this
      
    render_image_li: (image) ->
      image_li = new ImageLIView
        model: image
      this.$('ul.list').append image_li.render().el

  window.ImageLIView = Backbone.View.extend
    tagName: 'li'
    className: 'image sticker'
    
    initialize: () ->
      _.bindAll this, 'render'
      this.template = _.template JST['images/image_li'](this.model.toJSON())
      console.log this.model
      
    render: () ->
      this.$el.html this.template()
      this
