if Meteor.isClient

    Template.pegawai.helpers
        datas: -> pegawais.find().fetch()
        insert: -> Session.get 'insert'
        edit: -> Session.get 'update'
        data: -> pegawais.findOne _id: Session.get 'update'
    Template.pegawai.events
        'click #insert': ->
            Session.set 'insert', not Session.get 'insert'
        'click #remove': ->
            Meteor.call 'remove', this._id
        'click #update': ->
            Session.set 'update', this._id
        'click #close': ->
            Session.set 'update', false

    Template.diklat.helpers
        datas: -> diklats.find().fetch()
        insert: -> Session.get 'insert'
    Template.diklat.events
        'click #insert': ->
            Session.set 'insert', not Session.get 'insert'

    Template.rincian.helpers
        data: ->
            diklats.findOne()
