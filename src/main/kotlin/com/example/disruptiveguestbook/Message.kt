package com.example.disruptiveguestbook

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable
import java.util.*

@DynamoDBTable(tableName = "guestbook")
data class Message(
        @DynamoDBHashKey var id: String? = null,
        @DynamoDBAttribute var createdAt: Date? = null,
        @DynamoDBAttribute var fromUser: String? = null,
        @DynamoDBAttribute var text: String? = null,
        @DynamoDBAttribute var giphyLink: String? = null
)
