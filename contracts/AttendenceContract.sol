// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract NotesContract {
    uint256 public attendenceCounter = 0;

    struct Note {
        uint256 id;
        string name;
        string checkIn;
        string checkInLocation;
        string date;
    }

    mapping(uint256 => Note) public notes;

    event NoteCreated(uint256 id, string name, string checkIn, string checkInLocation, string date);
    event NoteDeleted(uint256 id);

    function createAttendence(string memory _checkIn, string memory _name, string memory _checkInLocation, string memory _date)
        public
    {
        notes[attendenceCounter] = Note(attendenceCounter, _name, _checkIn, _checkInLocation,_date);
        emit NoteCreated(attendenceCounter, _name, _checkIn, _checkInLocation,_date);
        attendenceCounter++;
    }

    function deleteNote(uint256 _id) public {
        delete notes[_id];
        emit NoteDeleted(_id);
        attendenceCounter--;
    }
}