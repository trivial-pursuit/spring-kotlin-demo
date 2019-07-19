package com.example.disruptiveguestbook

import com.mongodb.MongoClientURI
import com.mongodb.client.MongoCollection
import io.micronaut.context.annotation.Value
import org.litote.kmongo.KMongo
import org.litote.kmongo.eq
import javax.inject.Singleton

@Singleton
class MessageRepository(
        @Value("\${mongodb.uri}") private val mongoClientUri: String
) {

    private val mongoClient = KMongo.createClient(MongoClientURI(mongoClientUri))

    fun findAll(): List<Message> {
        return getCollection().find().toList()
    }

    fun findByFromUser(user: String): List<Message> {
        return getCollection().find(Message::fromUser eq user).toList()
    }

    fun save(message: Message): Message {
        getCollection().insertOne(message)
        return message
    }

    private fun getCollection(): MongoCollection<Message> {
        return mongoClient
                .getDatabase("test")
                .getCollection<Message>("message", Message::class.java)
    }
}
