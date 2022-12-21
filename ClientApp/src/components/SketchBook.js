import React, { Component } from 'react';
import Sketch from '../functions/Sketch';

export class SketchBook extends Component {
  static displayName = SketchBook.name;

  render() {
    return (
      <div>
        <h1>Your sketch book</h1>

        <p>Draw whatever you want!</p>

        <Sketch />
      </div>
    );
  }
}
