<%@ page contentType="text/html;charset=UTF-8" %>
    <style>
        #chatbot {
            position: fixed;
            bottom: 80px;
            right: 20px;
            width: 380px;
            height: 520px;
            border-radius: 12px;
            background: #fff;
            display: none;
            flex-direction: column;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            z-index: 9999;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        #chatbotHeader {
            background: #28a745;
            color: white;
            padding: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            cursor: move;
        }

        #chatbotHeader span {
            cursor: pointer;
        }

        #chatContent {
            flex: 1;
            padding: 10px;
            overflow-y: auto;
            font-size: 14px;
            background: #fafafa;
        }

        .message {
            margin: 8px 0;
            display: flex;
            align-items: flex-start;
        }

        .bot {
            color: #000;
        }

        .user {
            text-align: right;
            color: #333;
            justify-content: flex-end;
        }

        .bot img {
            width: 28px;
            height: 28px;
            margin-right: 8px;
        }

        .suggestions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-top: 10px;
        }

        .suggestions button {
            padding: 10px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            transition: 0.2s;
        }

        .suggestions button:hover {
            background: #28a745;
            color: white;
            border-color: #28a745;
        }

        #chatInput {
            display: flex;
            padding: 5px;
            border-top: 1px solid #eee;
        }

        #chatInput input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        #chatInput button {
            margin-left: 5px;
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            background: #28a745;
            color: white;
            cursor: pointer;
        }

        #openChatBtn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 14px;
            border-radius: 50%;
            cursor: pointer;
            z-index: 9999;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
            user-select: none;
        }
    </style>

    <div id="openChatBtn" onclick="openChat()">💬</div>

    <div id="chatbot">
        <div id="chatbotHeader">
            🤖 Trợ lý rau củ <span onclick="closeChat()">✖</span>
        </div>
        <div id="chatContent">
            <div class="message bot"><img src="https://cdn-icons-png.flaticon.com/512/4712/4712109.png" />
                <div>Xin chào 👋! Tôi có thể giúp gì cho bạn hôm nay?</div>
            </div>
            <div class="suggestions">
                <button onclick="quickMsg('Rau tươi hôm nay')">🥬 Rau tươi</button>
                <button onclick="quickMsg('Củ quả sạch')">🥕 Củ quả</button>
                <button onclick="quickMsg('Trái cây nhập khẩu')">🍎 Trái cây</button>
                <button onclick="quickMsg('Khuyến mãi hôm nay')">🔥 Khuyến mãi</button>
                <button onclick="quickMsg('Thông tin giao hàng')">🚚 Giao hàng</button>
                <button onclick="quickMsg('Liên hệ tư vấn')">☎️ Liên hệ</button>
            </div>
        </div>
        <div id="chatInput">
            <input type="text" id="message" placeholder="Nhập tin nhắn..." />
            <button onclick="sendMessage()">Gửi</button>
        </div>
    </div>

    <script>
        function openChat() {
            document.getElementById('chatbot').style.display = 'flex';
            document.getElementById('openChatBtn').style.display = 'none';
        }

        function closeChat() {
            document.getElementById('chatbot').style.display = 'none';
            document.getElementById('openChatBtn').style.display = 'block';
        }

        function quickMsg(msg) {
            document.getElementById('message').value = msg;
            sendMessage();
        }

        function sendMessage() {
            const input = document.getElementById('message');
            let msg = input.value.trim();
            if (!msg) return;
            const content = document.getElementById('chatContent');
            content.innerHTML += "<div class='message user'><div>Bạn: " + msg + "</div></div>";
            input.value = '';
            content.scrollTop = content.scrollHeight;

            fetch('<%=request.getContextPath()%>/chatbot', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'message=' + encodeURIComponent(msg)
            })
                .then(r => r.text())
                .then(reply => {
                    content.innerHTML += "<div class='message bot'><img src='https://cdn-icons-png.flaticon.com/512/4712/4712109.png'/><div>" + reply + "</div></div>";
                    content.scrollTop = content.scrollHeight;
                })
                .catch(err => {
                    content.innerHTML += "<div class='message bot'><b>Lỗi server:</b> " + err + "</div>";
                });
        }

        document.getElementById('message').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendMessage();
            }
        });

        // Draggable for chat window only
        makeDraggable(document.getElementById('chatbot'), document.getElementById('chatbotHeader'));

        function makeDraggable(element, handle) {
            let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            handle.onmousedown = dragMouseDown;

            function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                document.onmousemove = elementDrag;
            }

            function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
                element.style.top = (element.offsetTop - pos2) + "px";
                element.style.left = (element.offsetLeft - pos1) + "px";
            }

            function closeDragElement() {
                document.onmouseup = null;
                document.onmousemove = null;
            }
        }
    </script>