if Meteor.isServer

	Meteor.publish 'pegawais', (bid) ->
		if bid
			pegawais.find bidang: bid
		else
			pegawais.find {}

	Meteor.publish 'diklats', ->
		diklats.find {}

	Meteor.publish 'diklat', (id) ->	
		diklats.find _id: id

	Meteor.publish 'pesertas', (idDiklat) ->
		pesertas.find id_diklat: idDiklat

	Meteor.methods
		emptyDidaftarkan: ->
			pesertas.remove {}
		removeDiklat: (id) ->
			diklats.remove id
		removePegawai: (id) ->
			pegawais.remove _id: id

	###
	createUser = (obj) ->
		Accounts.createUser
			username: obj.value
			password: obj.value
	createUser i for i in users
	###
