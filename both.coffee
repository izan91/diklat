# Urusan Routing --------------------------------------------------------------
Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

Router.route '/pegawai',
	action: -> this.render 'pegawai'
	waitOn: -> Meteor.subscribe 'pegawais'

Router.route '/diklat',
	action: -> this.render 'diklat'
	waitOn: -> Meteor.subscribe 'diklats'

Router.route '/diklat/:id',
	action: -> this.render 'rincian'
	waitOn: -> [
		Meteor.subscribe 'diklat', this.params.id
		Meteor.subscribe 'pegawais'
		Meteor.subscribe 'pesertas', this.params.id
	]

Router.route '/login',
	action: -> this.render 'login'
Router.route '/logout',
	action: -> [Meteor.logout(), Router.go '/']

@users = [
	label: 'Sekretariat'
	value: 'sekre'
,
	label: 'Sumber Daya Air'
	value: 'sda'
,
	label: 'Pembangunan Jalan Jembatan'
	value: 'pembangunan'
,
	label: 'Preservasi Jalan Jembatan'
	value: 'preservasi'
,
	label: 'Air Minum dan Penyehatan Lingkungan'
	value: 'ampl'
,
	label: 'Penataan Ruang'
	value: 'tata_ruang'
,
	label: 'Penataan Bangunan'
	value: 'tata_bangunan'
,
	label: 'UPT Wilayah I'
	value: 'upt_wil1'
,
	label: 'UPT Wilayah II'
	value: 'upt_wil2'
,
	label: 'UPT Wilayah III'
	value: 'upt_wil3'
,
	label: 'UPT Jasa Konstruksi dan SDM'
	value: 'upt_jakon'
,
	label: 'UPT Pengujian Material'
	value: 'upt_pm'
,
	label: 'UPT PIP2B'
	value: 'upt_pip2b'
,
	label: 'UPT Pengelolaan Air Minum'
	value: 'upt_pam'
]
	
makeUser = (user) ->
	Router.route '/' + user,
		action: -> this.render 'pegawai'
		waitOn: -> Meteor.subscribe 'pegawais', user
makeUser i.value for i in users

# Urusan Database -------------------------------------------------------------
@pegawais = new Meteor.Collection 'pegawai'
pegawaiS = new SimpleSchema
	nama:
		type: String
		label: 'Nama Pegawai'
	nip:
		type: Number
		label: 'Nomor Induk Pegawai'
	pangkat:
		type: String
		label: 'Pangkat / Golongan'
	jabatan:
		type: String
		label: 'Jabatan Pegawai'
	bidang:
		type: String
		label: 'Bidang Pegawai'
		autoform:
			options: users
	kriteria:
		type: Array
	'kriteria.$':
		type: String	
	record:
		type: Array
		label: 'Diklat Diikuti'
		optional: true
	'record.$':
		type: Object
		optional: true
	'record.$.judul':
		type: String
	'record.$.tanggal':
		type: String
	'record.$.disiplin':
		type: String
	'record.$.tempat':
		type: String
pegawais.attachSchema pegawaiS
pegawais.allow
	insert: -> true
	update: -> true
	remove: -> true

@diklats = new Meteor.Collection 'diklat'
diklatS = new SimpleSchema
	judul:
		type: String
		label: 'Judul Diklat'
	tanggal:
		type: Date
		label: 'Jadwal Diklat'
	kriteria:
		type: Array
	'kriteria.$':
		type: String
	tempat:
		type: String
		label: 'Lokasi Diklat'
diklats.attachSchema diklatS
diklats.allow
	insert: -> true
	update: -> true
	remove: -> true

@pesertas = new Meteor.Collection 'peserta'
pesertaS = new SimpleSchema
	id_diklat:
		type: String
		autoform:
			type: 'hidden'
		autoValue: -> 
			if Meteor.isClient
				Router.current().params.id
		optional: true
	id_peserta:
		type: String
		label: 'ID Peserta'
		optional: true
		autoform: type: 'hidden'
	nama_peserta:
		type: String
		label: 'Nama Peserta'
		optional: true
pesertas.attachSchema pesertaS
pesertas.allow
	insert: -> true
	update: -> true
	remove: -> true
