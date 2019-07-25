package com.example.disruptiveguestbook

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable
import java.time.Instant
import java.util.*

@DynamoDBTable(tableName = "guestbook")
data class Message(
        @DynamoDBHashKey val id: UUID = UUID.randomUUID(),
        @DynamoDBAttribute val createdAt: Instant = Instant.now(),
        @DynamoDBAttribute val fromUser: String? = null,
        @DynamoDBAttribute val text: String,
        @DynamoDBAttribute val giphyLink: String? = null
)
