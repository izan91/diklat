if Meteor.isClient

	AutoForm.setDefaultTemplate 'materialize'

	Template.registerHelper 'insert', -> Session.get 'insert'
	Template.registerHelper 'edit', -> Session.get 'update'
	Template.registerHelper 'isAdmin', -> Meteor.user().username is 'admin'

	Template.body.events
		'click #insert': ->
			Session.set 'insert', not Session.get 'insert'
		'click #close': ->
			Session.set 'update', null
			Session.set 'editDiklat', null

	Template.pegawai.helpers
		datas: ->
			num = 0
			_.map pegawais.find().fetch().reverse(), (i) ->
				bidang = _.find users, (j) -> j.value is i.bidang
				i.bidang_modified = bidang.label
				++num; i.num = num
				i
		data: -> pegawais.findOne _id: Session.get 'update'

	Template.pegawai.events
		'click #update': ->
			Session.set 'update', this._id
		'click #removePegawai': ->
			Meteor.call 'removePegawai', this._id

	Template.diklat.helpers	
		diklats: ->
			num = 0
			_.map diklats.find().fetch().reverse(), (i) ->
				i.tanggal.mulai_modified = moment(i.tanggal.mulai).format('D MMM YYYY')
				i.tanggal.akhir_modified = moment(i.tanggal.akhir).format('D MMM YYYY')
				++num; i.num = num
				i
		insert: -> Session.get 'insert'
		editDiklat: -> Session.get 'editDiklat'

	Template.diklat.events
		'click #editDiklat': ->
			Session.set 'editDiklat', this
		'click #removeDiklat': ->
			data = this
			dialog =
				message: 'Yakin hapus Diklat ini?'
				title: 'Konfirmasi Hapus'
				okText: 'Ya'
				success: true
				focus: 'cancel'
			new Confirmation dialog, (ok) ->
				if ok then Meteor.call 'removeDiklat', data._id

	Template.rincian.helpers
		diklat: ->
			data = diklats.findOne()
			data.tanggal.mulai_modified = moment(data.tanggal.mulai).format('D MMM YYYY')
			data.tanggal.akhir_modified = moment(data.tanggal.akhir).format('D MMM YYYY')
			data
		pegawais: ->
			list = []
			for i in diklats.findOne().kriteria
				filter = _.filter pegawais.find().fetch(), (j) ->
					_.find j.kriteria, (k) -> k.includes i
				for j in filter
					list.push j
			_.filter list, (i) -> i.bidang is Meteor.user().username
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
					Router.go '/' + username

	AutoForm.addHooks null,
		after:
			insert: (err, res) -> if res
				Session.set 'insert', false
			update: (err, res) -> if res
				Session.set 'editDiklat', null
