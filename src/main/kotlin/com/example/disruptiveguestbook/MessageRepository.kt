package com.example.disruptiveguestbook

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression
import com.amazonaws.services.dynamodbv2.model.AttributeValue
import java.util.*
import javax.annotation.PostConstruct
import javax.inject.Singleton

@Singleton
class MessageRepository {

    private lateinit var client: AmazonDynamoDB
    private lateinit var mapper: DynamoDBMapper

    @PostConstruct
    fun init() {
        client = AmazonDynamoDBClientBuilder.standard().withRegion("eu-central-1").build()
        mapper = DynamoDBMapper(client)
    }

    fun findAll(): List<Message> {
        return mapper.scan(Message::class.java, DynamoDBScanExpression())
    }

    fun findByFromUser(user: String): List<Message> {
        val eav = HashMap<String, AttributeValue>()
        eav[":fromUser"] = AttributeValue().withS(user)

        val scanExpression = DynamoDBScanExpression()
                .withFilterExpression("fromUser = :fromUser")
                .withExpressionAttributeValues(eav)
                .withIndexName("FromUserIndex")

        return mapper.scan(Message::class.java, scanExpression)
    }

    fun save(message: Message): Message {
        mapper.save(message)

        return message
    }
}
