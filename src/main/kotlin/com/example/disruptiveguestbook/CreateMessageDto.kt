package com.example.disruptiveguestbook

import io.micronaut.core.annotation.Introspected

@Introspected
data class CreateMessageDto(
    val fromUser: String?,
    val text: String
)