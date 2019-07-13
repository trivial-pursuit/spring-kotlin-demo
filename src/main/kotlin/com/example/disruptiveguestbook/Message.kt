package com.example.disruptiveguestbook

import java.time.Instant
import java.util.*

data class Message(
    val id: UUID = UUID.randomUUID(),
    val createdAt: Instant = Instant.now(),
    val fromUser: String? = null,
    val text: String,
    val giphyLink: String? = null
)
