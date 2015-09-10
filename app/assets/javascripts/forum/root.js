var forum_root = {
    page_onload: function(head_active) {
        $('#'+head_active).addClass('active');
    },
    edit_topic: function(topic_id) {
        $.ajax({
            url: '/forum/'+topic_id+'/edit_topic',
            success: function(response) {
                $('#topic_'+topic_id).html(response);
            }
        });
    },
    edit_topic_post: function(topic_id) {
        var data_send = $('#edit_forum_article_'+topic_id).serialize();
        $.ajax({
            url: '/forum/'+topic_id+'/edit_topic_post',
            data: data_send,
            type: 'PATCH',
            success: function(response) {
                forum_root.single_topic_for_ajax(topic_id);
            }
        });
    },
    single_topic_for_ajax: function(topic_id) {
        $.ajax({
            url: '/forum/'+topic_id+'/single_topic_ajax',
            success: function(response) {
                $('#topic_'+topic_id).html(response);
            }
        });
    },
    delete_topic: function(topic_id) {
        var r = confirm("Are you sure?");
        if(r == true) {
            $.ajax({
                url: '/forum/'+topic_id+'/delete_topic',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                type: 'DELETE',
                success: function(response) {
                    $('#topic_'+topic_id).remove();
                }
            });
        }
    },
    single_reply_element: function(reply_id) {
        $.ajax({
            url: '/forum/'+reply_id+'/single_reply_ajax',
            success: function(response) {
                $('#reply_'+reply_id).html(response);
            }
        });
    },
    edit_reply: function(reply_id) {
        $.ajax({
            url: '/forum/'+reply_id+'/edit_reply',
            success: function(response) {                
                $('#reply_'+reply_id).html(response);
            }
        });
    },
    edit_reply_patch: function(reply_id) {
        var data_send = $('#forum_article_form_'+reply_id).serialize();
        $.ajax({
            url: '/forum/'+reply_id+'/edit_reply_patch',
            type: 'PATCH',
            data: data_send,
            success: function(response) {
                forum_root.single_reply_element(reply_id);
            }
        });
    },
    reply_delete: function(reply_id) {
        var r = confirm("Are you sure?");
        if(r == true) {
            $.ajax({
                url: '/forum/'+reply_id+'/reply_delete',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                type: 'DELETE',
                success: function(response) {
                    $('#reply_'+reply_id).remove();
                }
            });
        }
    }
};