require ["copy", "fileinto", "mailbox"];

#
# Spam First
#
if header :matches "X-Bogosity" "Spam*" {
   fileinto :create "0-Spam";
} elsif header :matches "X-Bogosity" "Unsure*" {
   fileinto :create :copy "0-Spam-unsure-copy";
}

