package com.example.disruptiveguestbook

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable
import com.fasterxml.jackson.annotation.JsonFormat
import io.micronaut.core.annotation.Introspected
import java.util.*

@Introspected
@DynamoDBTable(tableName = "guestbook")
data class Message(
        @DynamoDBHashKey var id: String? = null,
        @DynamoDBAttribute @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ssXXX") var createdAt: Date? = null,
        @DynamoDBAttribute var fromUser: String? = null,
        @DynamoDBAttribute var text: String? = null,
        @DynamoDBAttribute var giphyLink: String? = null
)
