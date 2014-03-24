{
    "lining"
:
    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is is an apple<=>This is is an apple;||;This is is an apple<=>This is is an apple;||;This is is an apple<=>This is is an apple"}
                ]},
            {"id": "285",
                "branch_questions": [
                    {"id": "182", "content": "<file>apple.jpg</file> <=> apple;||;<file>apple.jpg</file> <=> apple;||;<file>apple.jpg</file> <=> apple"}
                ]},
            {"id": "285",
                "branch_questions": [
                    {"id": "182", "content": "apple <=> <file>apple.jpg</file>;||;apple <=> <file>apple.jpg</file>;||;apple <=> <file>apple.jpg</file>"}
                ]},
            {"id": "291",
                "branch_questions": [
                    {"id": "182", "content": "<file>apple.jpg</file> <=> <file>apple.jpg</file>;||;<file>apple.jpg</file> <=> <file>apple.jpg</file>;||;<file>apple.jpg</file> <=> <file>apple.jpg</file>"}
                ]}
        ]
    }
,

    "sort"
:
    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple"}
                ]
            },

            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple"}
                ]
            }
        ]
    }
,

    "time_limit"
:

    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "282",
                "branch_questions": [
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "F"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "F"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "F"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "F"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"},
                    {"id": "179", "content": "Apple can eat?", "options":"T;||;F", "anwser": "T"}
                ]
            }
        ]
    }
,

    "cloze"
:

    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "282",
                "content": "This is [[tag]] apple,[[tag]] is a book.Car has [[tag]] wheels.",
                "branch_questions": [
                    {"id": "179", "options": "a;||;an;||;two", "answer": "an"},
                    {"id": "179", "options": "This;||;those;||;these", "answer": "This"},
                    {"id": "179", "options": "a;||;an;||;four", "answer": "This"}
                ]},
            {"id": "282",
                "content": "This is [[tag]] apple,[[tag]] is a book.Car has [[tag]] wheels.",
                "branch_questions": [
                    {"id": "179", "options": "a;||;an;||;two", "answer": "an"},
                    {"id": "179", "options": "This;||;those;||;these", "answer": "This"},
                    {"id": "179", "options": "a;||;an;||;four", "answer": "This"}
                ]}
        ]
    }
,

    "reading"
:

    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple!", "resource_url": "/question_packages/201402/questions_package_222/media_181.mp3"}
                ]},
            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple!", "resource_url": "/question_packages/201402/questions_package_222/media_181.mp3"}
                ]}
        ]
    }
,

    "listening"
:

    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "284",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple!", "resource_url": "/question_packages/201402/questions_package_222/media_181.mp3"}
                ]},
            {"id": "285",
                "branch_questions": [
                    {"id": "181", "content": "This is an apple!", "resource_url": "/question_packages/201402/questions_package_222/media_181.mp3"}
                ]}
        ]
    }
,

    "selecting"
:

    {
        "specified_time"
    :
        "100",
            "questions"
    :
        [
            {"id": "283",
                "branch_questions": [
                    {"id": "181", "content": "This is ______ apple!", "options": "a;||;an;||;two", "answer": "an" }
                ]},
         {"id": "284",
         "branch_questions": [
                              {"id": "182", "content": "<file>apple.jpg</file>选出图片中的单词", "options": "apple;||;banana;||;orange", "answer": "apple"}
                              ]},
         {"id": "285",
         "branch_questions": [
                              {"id": "183", "content": "<file>http://www.baidu.com</file>", "options": "apple;||;banana;||;orange", "answer": "apple;||;orange"}
                              ]}
        ]
    }
}
