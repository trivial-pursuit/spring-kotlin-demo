# disruptive-guestbook

Forked from [Thorsten Ludwig](https://github.com/ThorstenLudwig/spring-kotlin-demo) to demonstrate deployment to AWS in
the second talk at the [inovex Meetup](https://www.meetup.com/de-DE/inovex-Meetup-Hamburg/events/262668738/)

The [master branch](https://github.com/tobiasbayer/spring-kotlin-demo) contains
[Terraform](https://www.terraform.io)-configuration in the 
[deploy](https://github.com/tobiasbayer/spring-kotlin-demo/tree/master/deploy) directory
to deploy the original demo application to [AWS ECS](https://aws.amazon.com/ecs).

The tag [micronaut](https://github.com/tobiasbayer/spring-kotlin-demo/releases/tag/micronaut) then shows
how to move from [Spring Boot](https://spring.io/projects/spring-boot) to [Micronaut](https://micronaut.io/) as a 
preparation for deploying to AWS API Gateway and AWS Lambda instead.
The actual deployment is shown at the tag [lambda](https://github.com/tobiasbayer/spring-kotlin-demo/releases/tag/lambda).
For further reducing operations costs for smaller projects, the database is migrated from 
[MongoDB](https://www.mongodb.com) aka [DocumentDB](https://aws.amazon.com/documentdb) at AWS to 
[DynamoDB](https://aws.amazon.com/dynamodb) in this tag as well.


