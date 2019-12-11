package com.example.disruptiveguestbook

import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.Post
import org.slf4j.LoggerFactory
import javax.inject.Inject

@Controller
class GuestbookController(
        @Inject private val messageRepository: MessageRepository,
        @Inject private val giphyService: GiphyService
) {

    companion object {
        private val log = LoggerFactory.getLogger(GuestbookController::class.java)
    }

    @Get("/messages")
    fun getMessages(user: String?): List<Message> {
        log.info("Retrieving messages")

        return when (user) {
            null -> messageRepository.findAll().sortedBy { m -> m.createdAt }
            else -> messageRepository.findByFromUser(user).sortedBy { m -> m.createdAt }
        }
    }

    @Post("/messages")
    fun addMessage(message: CreateMessageDto): HttpResponse<CreateMessageDto> {

        val hashtag = extractHashtag(message.text)
        val giphyLink = hashtag?.let { giphyService.findUrlForTag(it) }

        messageRepository.save(Message(fromUser = message.fromUser, text = message.text, giphyLink = giphyLink))
        log.info("Message create {}", message)
        return HttpResponse.created(message)
    }

    private fun extractHashtag(text: String): String? {
        val hashtag = text.substringAfter('#',"").substringBefore(" ")

        return when (hashtag.isEmpty()) {
            true -> null
            false -> hashtag
        }
    }
}
