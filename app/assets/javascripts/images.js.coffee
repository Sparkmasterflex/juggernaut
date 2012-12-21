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
      
      this.images = new Images
        attachable_id: this.model.get('id')
        attachable_type: this.model.get('klass')
      this.images.fetch
        success: () => 
          @render_images()
          @render_image_form()
      this
    
    render_image_form: () ->
      window.imageForm = new ImageForm
        el: this.$('.col.left')
        model: new Image()
        images: this.images
        parent: 
          id: this.model.get('id')
          klass: this.model.get('klass')
      imageForm.render().el
    
    render_images: () ->
      window.imagesView = new ImagesView
        el: this.$('.col.right')
        collection: this.images
      imagesView.render().el

    
  window.ImageForm = Backbone.View.extend
    events:
      "click input[type=submit]": 'save_model'
      "click a.delete": 'cancel_edit'
      
    initialize: () ->
      _.bindAll this, 'render', 'fetch_images', 'save_model'
      this.images = this.options.images
      this.parent = this.options.parent
      
    render: () ->
      this.model.set 'parent', this.parent
      this.template = _.template JST['images/form'](this.model.toJSON())
      this.$el.html this.template()
      this

    save_model: (e) ->
      if this.model.isNew()
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
      else
        attrs =
          title: $('input#title').val()
          caption: $('textarea#caption').val()
          visible: $('input#visible').is(':checked')
        this.model.save attrs,
          wait: false
          success: (response) =>
            @model = new Image()
            @render()
          
      false
  
    fetch_images: () ->
      this.render()
      this.images.fetch()
      
    cancel_edit: (e) ->
      this.model = new Image()
      this.render()
      false


  window.ImagesView = Backbone.View.extend
    template: _.template JST['images/list']()
    
    initialize: () ->
      _.bindAll this, 'render'
      this.collection.bind 'reset', this.render
      
    render: () ->
      this.$el.html this.template()
      this.$('ul.list').empty() unless this.collection.length is 0
      this.render_image_li image for image in this.collection.models
      this.set_drag_drop()
      this
      
    render_image_li: (image) ->
      image_li = new ImageLIView
        model: image
      this.$('ul.list').append image_li.render().el
      
    set_drag_drop: () ->
      this.$srcElement = null
      this.srcIndex = null
      this.dstIndex = null
      
      $('li.sticker').dragdrop
        container: $('ul.list')
        makeClone: true
        sourceHide: true
        dragClass: "drag"
        canDrag: ($src, event) =>
          if $(event.target).is('a') and $(event.target).hasClass 'drag' 
            @$srcElement = $src
            @srcIndex = @$srcElement.index()
            @dstIndex = @srcIndex
            $src
          else
            false
        canDrop: ($dst) =>
          if $dst.is("li") 
            @dstIndex = $dst.index()
            if @srcIndex < @dstIndex
              @$srcElement.insertAfter($dst)
            else
              @$srcElement.insertBefore($dst)
          true
        didDrop: ($src, $dst) => @set_new_order $src, $dst
        
    set_new_order: (src, dst) ->
      img = this.collection.where({id: src.data('id')})[0]
      $.ajax
        url: "/images/#{img.get('id')}/reorder"
        type: 'POST'
        dataType: 'json' 
        data:
          _method: 'PUT'
          from: @srcIndex
          to: @dstIndex

  window.ImageLIView = Backbone.View.extend
    tagName: 'li'
    className: 'image sticker'
      
    events:
      'click a.edit': 'edit_image'
      'click a.visible': 'set_visibility'
      'click a.invisible': 'set_visibility'
      'click a.delete': 'delete_image'
    
    initialize: () ->
      _.bindAll this, 'render'
      this.model.bind 'change', this.render
      
    render: () ->
      this.template = _.template JST['images/image_li'](this.model.toJSON())
      this.$el.html this.template()
      this.$el.attr('data-id', this.model.get('id'))
      this
      
    edit_image: (e) ->
      this.model.set 'editing', true
      window.imageForm.model = this.model
      window.imageForm.render()
      false
      
    set_visibility: (e) ->
      this.model.save {visible: !this.model.get('visible')}
      false
      
    delete_image: (e) ->
      if confirm "Delete #{this.model.get('attachment_file_name')}?"
        this.model.destroy()
        this.remove()
      false
      