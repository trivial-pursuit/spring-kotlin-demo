package com.example.disruptiveguestbook

import com.mongodb.client.model.Filters.eq
import com.mongodb.reactivestreams.client.MongoClient
import com.mongodb.reactivestreams.client.MongoCollection
import io.reactivex.Flowable
import io.reactivex.Single
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MessageRepository(
        @Inject private val mongoClient: MongoClient
) {

    fun findAll(): List<Message> {
        return Flowable
                .fromPublisher(
                        getCollection()
                                .find()
                ).toList().blockingGet()
    }

    fun findByFromUser(user: String): List<Message> {
        return Flowable
                .fromPublisher(
                        getCollection()
                        .find(eq("fromUser", user))
        ).toList().blockingGet()
    }

    fun save(message: Message): Message{
        return Single
                .fromPublisher(getCollection()
                        .insertOne(message)).map { message }.blockingGet()
    }

    private fun getCollection(): MongoCollection<Message> {
        return mongoClient
                .getDatabase("test")
                .getCollection("message", Message::class.java)
    }
}
