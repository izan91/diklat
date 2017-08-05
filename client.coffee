if Meteor.isClient

	AutoForm.setDefaultTemplate 'materialize'

	Template.registerHelper 'insert', -> Session.get 'insert'
	Template.registerHelper 'edit', -> Session.get 'update'

	Template.body.events
		'click #insert': ->
			Session.set 'insert', not Session.get 'insert'
		'click #close': ->
			Session.set 'update', false

	Template.pegawai.helpers
		datas: ->
			_.map pegawais.find().fetch(), (i) ->
				bidang = _.find users, (j) -> j.value is i.bidang
				i.bidang_modified = bidang.label
				i
		data: -> pegawais.findOne _id: Session.get 'update'

	Template.pegawai.events
		'click #update': ->
			Session.set 'update', this._id
		'click #removePegawai': ->
			Meteor.call 'removePegawai', this._id

	Template.diklat.helpers	
		diklats: -> diklats.find().fetch()
		insert: -> Session.get 'insert'

	Template.diklat.events
		'click #removeDiklat': 
			Meteor.call 'removeDiklat', this._id

	Template.rincian.helpers
		diklat: -> diklats.findOne()
		pegawais: ->
			list = []
			for i in diklats.findOne().kriteria
				filter = _.filter pegawais.find().fetch(), (j) ->
					_.find j.kriteria, (k) -> k.includes i
				list = filter
			list
		collPeserta: -> pesertas
		pesertas: -> pesertas.find().fetch()

	Template.rincian.events
		'dblclick #item': ->
			$('[name="id_peserta"]').val this._id
			$('[name="nama_peserta"]').val this.nama
		'click #empty': ->
			Meteor.call 'emptyDidaftarkan'

	Template.login.events
		'submit #login': (event) ->
			event.preventDefault()
			username = event.target[0].value
			password = event.target[1].value
			Meteor.loginWithPassword username, password, (err) ->
				if err
					Materialize.toast err.reason, 4000
				else
					Router.go '/' + user
