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
        Meteor.subscribe 'pesertas'
    ]
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
    kriteria:
        type: String
        label: 'Disiplin Ilmu'
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
        type: String
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
        autoform: type: 'hidden'
        autoValue: -> 
            if Meteor.isClient
                Router.current().params.id
        optional: true
    id_peserta:
        type: String
        label: 'ID Peserta'
        optional: true
pesertas.attachSchema pesertaS
pesertas.allow
    insert: -> true
    update: -> true
    remove: -> true
# coll peserta untuk menghubungkan 2 tabel pegawa n diklat
