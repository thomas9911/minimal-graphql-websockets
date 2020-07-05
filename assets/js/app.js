// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
// import "phoenix_html"


import ApolloClient from "apollo-client";

import {
  InMemoryCache
} from 'apollo-cache-inmemory';
import {
  split
} from 'apollo-link';
import {
  HttpLink
} from 'apollo-link-http';
// import { WebSocketLink } from 'apollo-link-ws';
import {
  getMainDefinition
} from 'apollo-utilities';
import * as AbsintheSocket from "@absinthe/socket";
import {
  createAbsintheSocketLink
} from "@absinthe/socket-apollo-link";
import {
  Socket as PhoenixSocket
} from "phoenix";
import {
  gql
} from "apollo-boost";

const createClient = () => {
  const httpLink = new HttpLink({
    uri: 'http://localhost:4000/api'
  });

  // const wsLink = new WebSocketLink({
  //   uri: `ws://localhost:4000/socket/websocket?vsn=2.0.0`,
  //   options: {
  //     reconnect: true
  //   }
  // });

  const phoenixSocket = new PhoenixSocket("ws://localhost:4000/socket");

  // Wrap the Phoenix socket in an AbsintheSocket.
  const absintheSocket = AbsintheSocket.create(phoenixSocket);

  // Create an Apollo link from the AbsintheSocket instance.
  const wsLink = createAbsintheSocketLink(absintheSocket);


  // const client = new ApolloClient({
  //   uri: '/api',
  // });

  const link = split(
    // split based on operation type
    ({
      query
    }) => {
      const definition = getMainDefinition(query);
      return (
        definition.kind === 'OperationDefinition' &&
        definition.operation === 'subscription'
      );
    },
    wsLink,
    httpLink,
  );

  const client = new ApolloClient({
    link: link,
    cache: new InMemoryCache()
  });

  return client;
};

const handleResponseCommentList = (x) => {
  if (x.data) {
    const data = x.data;

    data.comments.forEach(element => {
      createCommentHTML(element)
    });
  }
};

const handleResponseCommentAdded = (x) => {
  if (x.data) {
    createCommentHTML(x.data.commentAdded);
  }
};

const createCommentHTML = (element) => {
  const div = document.createElement("div");
  div.id = `comment-${element.id}`;
  const title = document.createElement("h2");
  const inner_div = document.createElement("div");
  title.innerText = element.title;
  inner_div.innerText = element.content;
  div.appendChild(title);
  div.appendChild(inner_div);
  document.body.appendChild(div);
}

const createForm = (client) => {
  const form = document.createElement("form");
  const title_label = document.createElement("label");
  const title_input = document.createElement("input");
  title_input.id = "title_input";
  title_input.type = "text";
  title_label.innerText = "Title:";
  title_label.for = "title_input";
  const content_label = document.createElement("label");
  const content_input = document.createElement("textarea");
  content_input.id = "content_input";
  content_label.innerText = "Content:";
  content_label.for = "content_input";

  const submit = document.createElement("input");
  submit.type = "submit";
  submit.value = "Create";
  form.appendChild(title_label);
  form.appendChild(title_input);
  form.appendChild(content_label);
  form.appendChild(content_input);
  form.appendChild(submit);

  form.onsubmit = (e) => {
    e.preventDefault();
    const title = e.target[0].value;
    const content = e.target[1].value;

    if (!title | !content) {
      return false
    }

    client.mutate({
      mutation: gql`
      mutation createComment($content: String!, $title: String!, $repoName: String!) {
        submitComment(content: $content, title: $title, repoName: $repoName){
          id
        }
      }
      `,
      variables: {
        content: content,
        title: title,
        repoName: "ok"
      }
    }).then(x => x);;
  }
  document.body.appendChild(form);
};


const client = createClient();
createForm(client);

client.subscribe({
  query: gql`
  subscription addedComment($repoName: String!){
    commentAdded(repoName: $repoName){
      id
      title
      content
    }
  }
  `,
  variables: {
    repoName: "ok"
  }
}).subscribe(handleResponseCommentAdded);

client
  .query({
    query: gql`
      {
        comments {
          id
          title
          content
        }
      }
    `
  })
  .then(handleResponseCommentList);