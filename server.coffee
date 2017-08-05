if Meteor.isServer

    Meteor.publish 'pegawais', ->
            pegawais.find {}

    Meteor.publish 'diklats', ->
        diklats.find {}

    Meteor.publish 'diklat', (id) ->
        diklats.find _id: id

    Meteor.publish 'pesertas', (idDiklat) ->
        pesertas.find id_diklat: idDiklat
